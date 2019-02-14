require 'viaggiatreno/utils/scrape/scraper'

# Class to represent a train with its details
class Train
  attr_accessor :train_number, :train_name, :delay, :status, :last_update,
                :state

  def initialize(train_number)
    @train_number = train_number
    @scraper = TrainScraper.new(train_number.to_s, self)
    update
  end

  def update
    @scraper.update_train
  end

  def update_details
    @train_stops = []
    @scraper.update_train_details
  end

  def to_s
    "#{@train_number} #{@train_name}: #{@status} state: #{@state}, \
    delay: #{@delay}, last_update: #{@last_update}"
  end

  def add_stop(train_stop)
    @train_stops << train_stop
  end

  def train_stops
    update_details if @train_stops.nil?
    @train_stops
  end

  def departing_station
    train_stops.first.train_station.to_s
  end

  def arriving_station
    train_stops.last.train_station.to_s
  end

  def scheduled_departing_time
    train_stops.first.scheduled_stop_time.to_s
  end

  def scheduled_arriving_time
    train_stops.last.scheduled_stop_time.to_s
  end

  def scheduled_departing_rail
    train_stops.first.scheduled_rail
  end

  def actual_departing_rail
    train_stops.first.actual_rail
  end

  def scheduled_arriving_rail
    train_stops.last.scheduled_rail
  end

  def actual_arriving_rail
    train_stops.last.actual_rail
  end

  def actual_departing_time
    train_stops.first.actual_stop_time.to_s
  end

  def actual_arriving_time
    train_stops.last.actual_stop_time.to_s
  end

  def scheduled_stop_time(station_name)
    find_stop_time(station_name)['scheduled']
  end

  def actual_stop_time(station_name)
    find_stop_time(station_name)['actual']
  end

  def last_stop
    return train_stops.last.to_s if @state == TrainState::ARRIVED

    train_stops.each_with_index do |train_stop, index|
      if train_stop.status == TrainStopState::DONE && \
         train_stops[index + 1].status == TrainStopState::TO_BE_DONE
        return train_stop.to_s
      end
    end
    nil
  end

  private

  def find_stop_time(station_name)
    train_stops.each do |train_stop|
      if train_stop.train_station.to_s == station_name
        return \
        {
          'actual' => "#{train_stop.actual_stop_time} [#{train_stop.status}]",
          'scheduled' =>
            "#{train_stop.scheduled_stop_time} [#{train_stop.status}]"
        }
      end
    end
  end
end
