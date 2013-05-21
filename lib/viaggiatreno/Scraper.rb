require 'open-uri'
require 'nokogiri'
require_relative 'TrainStop'
require_relative 'TrainState'
require_relative 'StringUtils'
require_relative 'RegExpMatchInfo'
require_relative 'StopState'
require_relative 'XPathMatchInfo'
require_relative 'ViaggiatrenoURLs'

class Scraper

  def initialize(trainNumber, train)
    @site_info_main = ViaggiatrenoURLs.SITE_INFO_MAIN.gsub(
        RegExpMatchInfo.STR_TRAIN_NUMBER_URL_REPLACE, trainNumber)
    @site_info_details = ViaggiatrenoURLs.SITE_INFO_DETAILS.gsub(
        RegExpMatchInfo.STR_TRAIN_NUMBER_URL_REPLACE, trainNumber)
    @train = train
  end

  # fetch and parse basic train information (status, trainName, details)
  def updateTrain()
    doc = Nokogiri::HTML(open(@site_info_main))
    doc.xpath(XPathMatchInfo.XPATH_STATUS).each do |x|
      @status = StringUtils.remove_newlines_tabs_and_spaces(x)
    end
    doc.xpath(XPathMatchInfo.XPATH_TRAIN_NAME).each do |x|
      @trainName = x.content
    end
    if @status =~ RegExpMatchInfo.REGEXP_STATE_NOT_STARTED
      @train.state = TrainState.NOT_STARTED
    elsif @status =~ RegExpMatchInfo.REGEXP_STATE_RUNNING or \
        RegExpMatchInfo.REGEXP_STATE_FINISHED
      if @status =~ RegExpMatchInfo.REGEXP_NODELAY_STR
        @train.delay = 0
      else 
        @train.delay = @status.match(RegExpMatchInfo.REGEXP_DELAY_STR)[1].to_i
        if @status.match(RegExpMatchInfo.REGEXP_DELAY_STR)[2] \
            != RegExpMatchInfo.STR_DELAY_STR
          # train is ahead of time, delay is negative
          @train.delay *= -1
        end
      end
      if @status =~ RegExpMatchInfo.REGEXP_STATE_RUNNING
        @train.state = TrainState.RUNNING
        @train.lastUpdate = @status.match(
            RegExpMatchInfo.REGEXP_STATE_RUNNING)[3].strip
        @status = @status.match(RegExpMatchInfo.REGEXP_STATE_RUNNING)[1].rstrip
      else
        @train.state = TrainState.FINISHED
      end
    end

    @train.status = @status
    @train.trainName = @trainName
  end
 
  # fetch and parse train details (departing and arriving station, 
  # intermediate stops)
  def updateTrainDetails()
    doc = Nokogiri::HTML(open(@site_info_details))
    doc.xpath(XPathMatchInfo.XPATH_DETAILS_GENERIC).each do |x|
      x.xpath(XPathMatchInfo.XPATH_DETAILS_STATION_NAME).each do |stationName|
        @stationName = stationName.to_s
      end
      x.xpath(XPathMatchInfo.XPATH_DETAILS_SCHEDULED_STOP_TIME).each do \
          |scheduledArrivalTime|
        @scheduledArrivalTime = StringUtils.remove_newlines_tabs_and_spaces(
            scheduledArrivalTime).to_s
      end
      x.xpath(XPathMatchInfo.XPATH_DETAILS_ACTUAL_STOP_TIME).each do \
          |actualArrivalTime|
        @actualArrivalTime = StringUtils.remove_newlines_tabs_and_spaces(
            actualArrivalTime).to_s
      end
      if x.attributes()['class'].to_s =~ RegExpMatchInfo.REGEXP_STOP_ALREADY_DONE
        t = TrainStop.new(@stationName, @scheduledArrivalTime, 
                          @actualArrivalTime, StopState.DONE)
      else
        t = TrainStop.new(@stationName, @scheduledArrivalTime, 
                          @actualArrivalTime, StopState.TODO)
      end
      @train.addStop(t)
    end
  end
end

