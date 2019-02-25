require 'viaggiatreno/utils/scrape/scraper'

# Class to represent a train with its details
class Train
  attr_accessor :train_number, :train_name, :delay, :status, :last_update,
                :state, :stops

  def initialize(train_number)
    @train_number = train_number
    @scraper = TrainScraper.new(self)
    @stops = []
    update
  end

  def update
    @stops = []
    @scraper.update
  end

  def add_stop(stop)
    @stops << stop
  end

  def departing_station
    stops.each do |stop|
      if stop.state == TrainStopState::DONE || stop.state == TrainStopState::TO_BE_DONE
        return stop.train_station
      end
    end
  end

  def arriving_station
    if state != TrainState::TRAVELING
      stops.reverse_each do |stop|
        return stop.train_station if stop.state == TrainStopState::DONE
      end
    end
    stops.last.train_station
  end

  def scheduled_departing_time
    stops.each do |stop|
      if stop.state == TrainStopState::DONE || stop.state == TrainStopState::TO_BE_DONE
        return stop.scheduled_stop_time
      end
    end
  end

  def scheduled_arriving_time
    stops.last.scheduled_stop_time
  end

  def scheduled_departing_platform
    stops.first.scheduled_platform
  end

  def scheduled_arriving_platform
    stops.last.scheduled_platform
  end

  def scheduled_stop_time(station_name)
    find_stop(station_name).scheduled_stop_time
  end

  def actual_departing_time
    stops.each do |stop|
      if stop.state == TrainStopState::DONE || stop.state == TrainStopState::TO_BE_DONE
        return stop.actual_stop_time
      end
    end
  end

  def actual_arriving_time
    if state == TrainState::NOT_DEPARTED || state == TrainState::SUPPRESSED
      return nil
    end

    stops.last.actual_stop_time
  end

  def actual_departing_platform
    if state == TrainState::NOT_DEPARTED || state == TrainState::SUPPRESSED
      return nil
    end
    stops.first.actual_platform
  end

  def actual_arriving_platform
    return nil if state == TrainState::NOT_DEPARTED

    stops.last.actual_platform
  end

  def actual_stop_time(station_name)
    find_stop(station_name).actual_stop_time
  end

  def last_stop
    return nil if state == TrainState::NOT_DEPARTED || state == TrainState::SUPPRESSED

    stops.each_with_index do |stop, index|
      if index != stops.size - 1 && stop.state == TrainStopState::DONE &&
         stops[index + 1].state != TrainStopState::DONE
        return stop
      end
    end
    stops.last
  end

  def find_stop(station_name)
    stops.each do |stop|
      return stop if stop.train_station.casecmp(station_name).zero?
    end
    raise StopNotFound.new
  end
end
