require 'open-uri'
require 'nokogiri'
require_relative 'train_stop'
require_relative 'train_state'
require_relative 'string_utils'
require_relative 'regex_match_info'
require_relative 'train_stop_state'
require_relative 'xpath_match_info'
require_relative 'viaggiatreno_urls'

# Class to scrape data from viaggiatreno website
class Scraper
  def initialize(train_number, train)
    @site_info_main = ViaggiatrenoURLs::SITE_INFO_MAIN.gsub(
      RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE, train_number
    )
    @site_info_details = ViaggiatrenoURLs::SITE_INFO_DETAILS.gsub(
      RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE, train_number
    )
    @train = train
  end

  # fetch and parse basic train information (status, train_name, details)
  def update_train
    @doc = Nokogiri::HTML(URI.parse(@site_info_main).open)
    @train.status = StringUtils.remove_newlines_tabs_and_spaces(
      @doc.xpath(XPathMatchInfo::XPATH_STATUS).first
    )
    @train.train_name = @doc.xpath(XPathMatchInfo::XPATH_TRAIN_NAME)
                            .first.content
    update_train_status(@train)
    @train.delay = fetch_train_delay(@train.status)
    nil
  end

  def update_train_status(train)
    if train.status =~ RegExpMatchInfo::REGEXP_STATE_NOT_DEPARTED
      train.state = TrainState::NOT_DEPARTED
    elsif train.status =~ RegExpMatchInfo::REGEXP_STATE_ARRIVED
      train.state = TrainState::ARRIVED
    elsif train.status =~ RegExpMatchInfo::REGEXP_STATE_TRAVELING
      train.state = TrainState::TRAVELING
      regex_match = train.status.match(
        RegExpMatchInfo::REGEXP_STATE_TRAVELING
      )
      train.last_update = regex_match[3].strip
      train.status = regex_match[1].rstrip
    end
  end

  def fetch_train_delay(status)
    return nil if @train.state == TrainState::NOT_DEPARTED

    if status =~ RegExpMatchInfo::REGEXP_NODELAY_STR
      delay = 0
    else
      delay = status.match(
        RegExpMatchInfo::REGEXP_DELAY_STR
      )[1].to_i
      if status.match(RegExpMatchInfo::REGEXP_DELAY_STR)[2] !=
         RegExpMatchInfo::STR_DELAY_STR
        delay *= -1 # train is ahead of schedule, delay is negative
      end
    end
    delay
  end

  # fetch and parse train details (departing and arriving station,
  # intermediate stops)
  def update_train_details
    doc = Nokogiri::HTML(URI.parse(@site_info_details).open)
    doc.xpath(XPathMatchInfo::XPATH_DETAILS_GENERIC)
       .each_with_index do |xml, index|
      @station_name = xml.xpath(XPathMatchInfo::XPATH_DETAILS_STATION_NAME)
                         .first.to_s
      arrival_time = fetch_trainstop_arrival_time(xml)
      rail = fetch_trainstop_rail(xml, index)
      @status = update_trainstop_status(xml, @train)
      @train.add_stop(
        TrainStop.new(@station_name, arrival_time, rail, @status)
      )
    end
  end

  def update_trainstop_status(xml, train)
    status = if xml.attributes['class'].to_s =~
                RegExpMatchInfo::REGEXP_STOP_ALREADY_DONE && \
                train.state != TrainState::NOT_DEPARTED
               TrainStopState::DONE
             else
               TrainStopState::TO_BE_DONE
             end
    status
  end

  def fetch_trainstop_rail(xpath, departing_station)
    if departing_station.zero?
      xpath = @doc.xpath(XPathMatchInfo::XPATH_TRAIN_GENERIC_INFO)
      xpath = xpath.first
    end
    scheduled_rail, actual_rail = fetch_rail(xpath)
    scheduled_rail = nil if scheduled_rail == '--'
    actual_rail = nil if actual_rail == '--'
    [scheduled_rail, actual_rail]
  end

  def fetch_rail(xpath)
    scheduled_rail = StringUtils.remove_newlines_tabs_and_spaces(xpath)
                                .match(
                                  RegExpMatchInfo::REGEXP_SCHEDULED_RAIL
                                )[1]
    actual_rail = StringUtils.remove_newlines_tabs_and_spaces(xpath)
                             .match(
                               RegExpMatchInfo::REGEXP_ACTUAL_RAIL
                             )[1]
    [scheduled_rail, actual_rail]
  end

  def fetch_trainstop_arrival_time(xpath)
    scheduled_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
      xpath.xpath(XPathMatchInfo::XPATH_DETAILS_SCHEDULED_STOP_TIME).first
    ).to_s
    actual_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
      xpath.xpath(XPathMatchInfo::XPATH_DETAILS_ACTUAL_STOP_TIME).first
    ).to_s
    [scheduled_arrival_time, actual_arrival_time]
  end
end
