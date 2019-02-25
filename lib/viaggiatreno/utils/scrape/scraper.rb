require 'mechanize'

require 'viaggiatreno/utils/scrape/viaggiatreno_urls'
require 'viaggiatreno/utils/string/string_utils'
require 'viaggiatreno/utils/xpath/xpath_match_info'
require 'viaggiatreno/model/train/train_state'
require 'viaggiatreno/model/station/train_stop_state'
require 'viaggiatreno/model/station/train_stop'

# Class to scrape train data from viaggiatreno website
class TrainScraper
  def initialize(train)
    @train = train
  end

  # fetch and parse basic train information (status, train_name, details)
  def update
    agent = Mechanize.new
    agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample
    page = agent.get(ViaggiatrenoURLs::VIAGGIATRENO_URL)
    page.forms.first.fields.first.value = @train.train_number
    result = agent.submit(page.forms.first)

    begin
      @result_train = result.forms.first.submit # TODO levenshtein distance?
    rescue NoMethodError
      @result_train = result
    end

    error = StringUtils.remove_newlines_tabs_and_spaces(@result_train.search(XPathMatchInfo::SEARCH_ERROR).text)
    if error != StringUtils::EMPTY_STRING
      @train.train_number = nil
      return
    end
    @train.status = StringUtils.remove_newlines_tabs_and_spaces(@result_train.search(XPathMatchInfo::TRAIN_STATUS).text)
    extraordinary_event = StringUtils.remove_newlines_tabs_and_spaces(@result_train.search(XPathMatchInfo::TRAIN_EXTRAORDINARY_EVENT).text)
    @train.status += '. ' + extraordinary_event if extraordinary_event != StringUtils::EMPTY_STRING
    @train.train_name = @result_train.search(XPathMatchInfo::TRAIN_NAME)
                                     .first.content
    update_train_status(@train)
    fetch_train_delay

    stops_detail_link = @result_train.link_with text: StringUtils::STOPS_DETAIL
    @result_train_detail = agent.get(stops_detail_link.click)
    @result_train_detail.search(XPathMatchInfo::TRAIN_DETAILS_GENERIC)
                        .each_with_index do |xml, index|
      station_name = xml.search(XPathMatchInfo::TRAIN_DETAILS_STATION_NAME)
                        .first.text
      arrival_time = fetch_trainstop_arrival_time(xml)
      platform = fetch_platform(xml, index)
      train_stop_state = update_trainstop_status(xml, @train)
      @train.add_stop(
        TrainStop.new(station_name, arrival_time, platform, train_stop_state)
      )
    end
    nil
  end

  def update_train_status(train)
    if train.status =~ RegExMatchInfo::TRAIN_STATE_NOT_DEPARTED
      train.state = TrainState::NOT_DEPARTED
    elsif train.status =~ RegExMatchInfo::TRAIN_STATE_ARRIVED
      train.state = TrainState::ARRIVED
    elsif train.status =~ RegExMatchInfo::TRAIN_STATE_TRAVELING
      train.state = TrainState::TRAVELING
      regex_match = train.status.match(
        RegExMatchInfo::TRAIN_STATE_TRAVELING
      )
      train.last_update = regex_match[2].strip
      train.status = regex_match[1].rstrip
    end
  end

  def fetch_train_delay
    return nil if @train.state == TrainState::NOT_DEPARTED || @train.state == TrainState::SUPPRESSED

    if @train.status =~ RegExMatchInfo::TRAIN_NODELAY_STR
      @train.delay = 0
    else
      @train.delay = @train.status.match(RegExMatchInfo::TRAIN_DELAY_STR)[1].to_i
      unless @train.status.match(RegExMatchInfo::TRAIN_DELAY_STR)[2].casecmp(StringUtils::DELAY_STR).zero?
        @train.delay *= -1 # train is ahead of schedule, delay is negative
      end
    end
  end

  def update_trainstop_status(xml, train)
    status = if xml.attributes['class'].value =~
                RegExMatchInfo::TRAIN_STOP_ALREADY_DONE &&
                train.state != TrainState::NOT_DEPARTED && xml.search(XPathMatchInfo::TRAIN_DETAILS_SUPPRESSED_STOP).text == StringUtils::EMPTY_STRING
               TrainStopState::DONE
             elsif train.status =~ RegExMatchInfo::TRAIN_STATE_ARRIVED || xml.search(XPathMatchInfo::TRAIN_DETAILS_SUPPRESSED_STOP).text == StringUtils::SUPPRESSED_STOP
               TrainStopState::SUPPRESSED
             else
               TrainStopState::TO_BE_DONE
             end
    status
  end

  def fetch_platform(xpath, index)
    regex_match = StringUtils.remove_newlines_tabs_and_spaces(xpath.text)
                             .match(RegExMatchInfo::TRAIN_STOP_PLATFORM)
    scheduled_platform = regex_match[1].strip
    actual_platform = regex_match[2].strip

    if (index.zero? || index == (@result_train_detail.search(XPathMatchInfo::TRAIN_DETAILS_GENERIC).size - 1)) && (scheduled_platform == StringUtils::EMPTY_STRING || actual_platform == StringUtils::EMPTY_STRING)
      if index.zero?
        second_match = StringUtils.remove_newlines_tabs_and_spaces(@result_train.search(XPathMatchInfo::TRAIN_DETAILS_GENERIC)[0].text).match(RegExMatchInfo::TRAIN_STOP_PLATFORM)
        scheduled_platform = second_match[1].strip
        actual_platform = second_match[2].strip
      elsif index == (@result_train_detail.search(XPathMatchInfo::TRAIN_DETAILS_GENERIC).size - 1)
        if @train.state == TrainState::ARRIVED || @train.state == TrainState::NOT_DEPARTED
          second_match = StringUtils.remove_newlines_tabs_and_spaces(@result_train.search(XPathMatchInfo::TRAIN_DETAILS_GENERIC)[1].text).match(RegExMatchInfo::TRAIN_STOP_PLATFORM)
        else
          second_match = StringUtils.remove_newlines_tabs_and_spaces(@result_train.search(XPathMatchInfo::TRAIN_DETAILS_GENERIC)[2].text).match(RegExMatchInfo::TRAIN_STOP_PLATFORM)
        end
        scheduled_platform = second_match[1].strip
        actual_platform = second_match[2].strip
      end
    end
    
    scheduled_platform = nil if scheduled_platform == StringUtils::EMPTY_STRING
    actual_platform = nil if actual_platform == StringUtils::EMPTY_STRING || @train.state == TrainState::NOT_DEPARTED || @train.state == TrainState::SUPPRESSED

    [scheduled_platform, actual_platform]
  end

  def fetch_trainstop_arrival_time(xpath)
    scheduled_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
      xpath.search(XPathMatchInfo::TRAIN_DETAILS_SCHEDULED_STOP_TIME).first.text
    )
    actual_arrival_time = StringUtils.remove_newlines_tabs_and_spaces(
      xpath.search(XPathMatchInfo::TRAIN_DETAILS_ACTUAL_STOP_TIME).first.text
    )
    scheduled_arrival_time = nil if scheduled_arrival_time == StringUtils::EMPTY_STRING
    actual_arrival_time = nil if actual_arrival_time == StringUtils::EMPTY_STRING || @train.state == TrainState::NOT_DEPARTED || @train.state == TrainState::SUPPRESSED
    [scheduled_arrival_time, actual_arrival_time]
  end
end

# Class to scrape station data from viaggiatreno website
class StationScraper
  def initialize(station_name, station)
    @station_name = station_name
    @station = station
  end

  def update
    agent = Mechanize.new
    page = agent.get(ViaggiatrenoURLs.site_station_info_url)
    page.forms.first.fields.first.value = @station_name
    @result = agent.submit(page.forms.first)

    processing_outgoing_trains = false

    error = StringUtils.remove_newlines_tabs_and_spaces(@result.search(XPathMatchInfo::SEARCH_ERROR).text)
    if error != StringUtils::EMPTY_STRING
      @station.station_name = nil
      return
    end

    @station.station_name = @result.search(XPathMatchInfo::STATION_NAME).text.match(RegExMatchInfo::STATION_NAME)[1].strip
    @result.search(XPathMatchInfo::STATION_LIST)
           .each do |result|
      if result.attributes[StringUtils::CLASS_ATTRIBUTE_NAME].value == StringUtils::RESULT_BLOCK
        train_number = result.search(XPathMatchInfo::STATION_TRAIN_NUMBER).text.split(StringUtils::WHITESPACE)[1]
        train = Train.new(train_number)
        if processing_outgoing_trains
          @station.outgoing_trains.append(train)
        else
          @station.incoming_trains.append(train)
        end
      end
      if result.attributes[StringUtils::CLASS_ATTRIBUTE_NAME].value == StringUtils::RESULT_CENTRAL
        processing_outgoing_trains = !processing_outgoing_trains
        next
      end
    end
  end
end
