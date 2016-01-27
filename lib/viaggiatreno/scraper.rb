require 'open-uri'
require 'nokogiri'
require_relative 'train_stop'
require_relative 'train_state'
require_relative 'string_utils'
require_relative 'regex_match_info'
require_relative 'train_stop_state'
require_relative 'xpath_match_info'
require_relative 'viaggiatreno_urls'

class Scraper
  def initialize(train_number, train)
    @site_info_main = ViaggiatrenoURLs::SITE_INFO_MAIN.gsub(
      RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE, train_number)
    @site_info_details = ViaggiatrenoURLs::SITE_INFO_DETAILS.gsub(
      RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE, train_number)
    @train = train
  end

  # fetch and parse basic train information (status, train)name, details)
  def update_train
    doc = Nokogiri::HTML(open(@site_info_main))
    @train.status = StringUtils.remove_newlines_tabs_and_spaces(
      doc.xpath(XPathMatchInfo::XPATH_STATUS).first)
    @train.train_name = doc.xpath(XPathMatchInfo::XPATH_TRAIN_NAME).first.content
    update_train_status(@train)
    @train.delay = fetch_train_delay(@train.status)
  end

  def update_train_status(train)
    case
    when train.status =~ RegExpMatchInfo::REGEXP_STATE_NOT_DEPARTED
      train.state = TrainState::NOT_DEPARTED
    when train.status =~ RegExpMatchInfo::REGEXP_STATE_ARRIVED
      train.state = TrainState::ARRIVED
    when train.status =~ RegExpMatchInfo::REGEXP_STATE_TRAVELING
      train.state = TrainState::TRAVELING
      regex_match = train.status.match(
        RegExpMatchInfo::REGEXP_STATE_TRAVELING)
      train.last_update = regex_match[3].strip
      train.status = regex_match[1].rstrip
    end
  end

  def fetch_train_delay(status)
    return nil if @train.state == TrainState::NOT_DEPARTED
    if status =~ RegExpMatchInfo::REGEXP_NODELAY_STR
      delay = 0
    else
      delay = status.match(RegExpMatchInfo::REGEXP_DELAY_STR)[1].to_i
      if status.match(RegExpMatchInfo::REGEXP_DELAY_STR)[2] != RegExpMatchInfo::STR_DELAY_STR
        delay *= -1 # train is ahead of schedule, delay is negative
      end
    end
    delay
  end

  # fetch and parse train details (departing and arriving station,
  # intermediate stops)
  def update_train_details
    doc = Nokogiri::HTML(open(@site_info_details))
    doc.xpath(XPathMatchInfo::XPATH_DETAILS_GENERIC).each do |x|
      @station_name = x.xpath(XPathMatchInfo::XPATH_DETAILS_STATION_NAME).first.to_s
      arrival_time = fetch_trainstop_arrival_time(x)
      rail = fetch_trainstop_rail(x)
      @status = update_trainstop_status(x, @train, @status)
      @train.add_stop(TrainStop.new(
                        @station_name, arrival_time, rail, @status))
    end
  end

  def update_trainstop_status(x, train, status)
    status = if x.attributes['class'].to_s =~ RegExpMatchInfo::REGEXP_STOP_ALREADY_DONE && \
                train.state != TrainState::NOT_DEPARTED
               TrainStopState::DONE
             else
               TrainStopState::TO_BE_DONE
             end
    status
  end

  def fetch_trainstop_rail(xpath)
    scheduled_rail = StringUtils.remove_newlines_tabs_and_spaces(xpath).match(
      RegExpMatchInfo::REGEXP_SCHEDULED_TRACK)[1]
    scheduled_rail = nil if scheduled_rail == '--'
    actual_rail = StringUtils.remove_newlines_tabs_and_spaces(xpath).match(
      RegExpMatchInfo::REGEXP_ACTUAL_TRACK)[1]
    actual_rail = nil if actual_rail == '--'
    {
      'scheduled_rail' => scheduled_rail,
      'actual_rail' => actual_rail
    }
  end

  def fetch_trainstop_arrival_time(xpath)
    scheduled_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
      xpath.xpath(XPathMatchInfo::XPATH_DETAILS_SCHEDULED_STOP_TIME).first).to_s
    actual_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
      xpath.xpath(XPathMatchInfo::XPATH_DETAILS_ACTUAL_STOP_TIME).first).to_s
    {
      'scheduled_arrival_time' => scheduled_arrival_time,
      'actual_arrival_time' => actual_arrival_time
    }
  end
end
