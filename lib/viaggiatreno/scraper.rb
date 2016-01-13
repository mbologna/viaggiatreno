require 'open-uri'
require 'nokogiri'
require_relative 'train_stop'
require_relative 'train_state'
require_relative 'string_utils'
require_relative 'regex_match_info'
require_relative 'stop_state'
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
    if @status =~ RegExpMatchInfo::REGEXP_STATE_NOT_STARTED
      @train.state = TrainState::NOT_STARTED
    elsif @status =~ RegExpMatchInfo::REGEXP_STATE_RUNNING || RegExpMatchInfo::REGEXP_STATE_FINISHED
      if @status =~ RegExpMatchInfo::REGEXP_NODELAY_STR
        @train.delay = 0
      else
        @train.delay = @status.match(RegExpMatchInfo::REGEXP_DELAY_STR)[1].to_i
        if @status.match(RegExpMatchInfo::REGEXP_DELAY_STR)[2] \
            != RegExpMatchInfo::STR_DELAY_STR
          # train is ahead of schedule, delay is negative
          @train.delay *= -1
        end
      end
      if @status =~ RegExpMatchInfo::REGEXP_STATE_RUNNING
        @train.state = TrainState::RUNNING
        @train.last_update = @status.match(
          RegExpMatchInfo::REGEXP_STATE_RUNNING)[3].strip
        @status = @status.match(RegExpMatchInfo::REGEXP_STATE_RUNNING)[1].rstrip
      else
        @train.state = TrainState::FINISHED
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
      x.xpath(XPathMatchInfo::XPATH_DETAILS_STATION_NAME).each do |station_name|
        @station_name = station_name.to_s
      end
      x.xpath(XPathMatchInfo::XPATH_DETAILS_SCHEDULED_STOP_TIME).each do |scheduled_arrival_time|
        @scheduled_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
          scheduled_arrival_time).to_s
      end
      x.xpath(XPathMatchInfo::XPATH_DETAILS_ACTUAL_STOP_TIME).each do |actual_arrival_time|
        @actual_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
          actual_arrival_time).to_s
      end
      if x.attributes['class'].to_s =~ RegExpMatchInfo::REGEXP_STOP_ALREADY_DONE
        t = TrainStop.new(@station_name, @scheduled_arrival_time,
                          @actual_arrival_time, StopState::DONE)
      else
        t = TrainStop.new(@station_name, @scheduled_arrival_time,
                          @actual_arrival_time, StopState::TODO)
      end
      @train.add_stop(t)
    end
  end
end
