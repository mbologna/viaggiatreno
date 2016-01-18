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
    doc.xpath(XPathMatchInfo::XPATH_STATUS).each do |x|
      @status = StringUtils.remove_newlines_tabs_and_spaces(x)
    end
    doc.xpath(XPathMatchInfo::XPATH_TRAIN_NAME).each do |x|
      @train_name = x.content
    end
    if @status =~ RegExpMatchInfo::REGEXP_STATE_NOT_DEPARTED
      @train.state = TrainState::NOT_DEPARTED
    elsif @status =~ RegExpMatchInfo::REGEXP_STATE_TRAVELING || \
          RegExpMatchInfo::REGEXP_STATE_ARRIVED
      if @status =~ RegExpMatchInfo::REGEXP_NODELAY_STR
        @train.delay = 0
      else
        @train.delay = @status.match(RegExpMatchInfo::REGEXP_DELAY_STR)[1].to_i
        if @status.match(RegExpMatchInfo::REGEXP_DELAY_STR)[2] != RegExpMatchInfo::STR_DELAY_STR
          @train.delay *= -1 # train is ahead of schedule, delay is negative
        end
      end
      if @status =~ RegExpMatchInfo::REGEXP_STATE_TRAVELING
        @train.state = TrainState::TRAVELING
        @train.last_update = @status.match(
          RegExpMatchInfo::REGEXP_STATE_TRAVELING)[3].strip
        @status = @status.match(RegExpMatchInfo::REGEXP_STATE_TRAVELING)[1].rstrip
      else
        @train.state = TrainState::ARRIVED
      end
    end
    @train.status = @status
    @train.train_name = @train_name
  end

  # fetch and parse train details (departing and arriving station,
  # intermediate stops)
  def update_train_details
    doc = Nokogiri::HTML(open(@site_info_details))
    doc.xpath(XPathMatchInfo::XPATH_DETAILS_GENERIC).each do |x|
      @station_name = x.xpath(XPathMatchInfo::XPATH_DETAILS_STATION_NAME).first.to_s
      @scheduled_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
        x.xpath(XPathMatchInfo::XPATH_DETAILS_SCHEDULED_STOP_TIME).first).to_s
      @actual_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
        x.xpath(XPathMatchInfo::XPATH_DETAILS_ACTUAL_STOP_TIME).first).to_s
      @status = if x.attributes['class'].to_s =~ RegExpMatchInfo::REGEXP_STOP_ALREADY_DONE && \
                   @train.state != TrainState::NOT_DEPARTED
                  TrainStopState::DONE
                else
                  TrainStopState::TO_BE_DONE
                end
      @train.add_stop(TrainStop.new(
                        @station_name, @scheduled_arrival_time,
                        @actual_arrival_time, @status))
    end
  end
end
