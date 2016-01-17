require_relative 'scraper.rb'
require_relative 'train_state.rb'
require_relative 'train_stop.rb'

class Train
  attr_accessor :train_number, :train_name, :delay, :status, :last_update, :state

  def initialize(train_number)
    @train_number = train_number
    @scraper = Scraper.new(train_number.to_s, self)
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

  def actual_departing_time
    train_stops.first.actual_stop_time.to_s
  end

  def actual_arriving_time
    train_stops.last.actual_stop_time.to_s
  end

  def scheduled_stop_time(station_name)
    train_stops.each do |train_stop|
      if train_stop.train_station.to_s == station_name
        return "#{train_stop.scheduled_stop_time} [#{train_stop.status}]"
      end
    end
  end

  def actual_stop_time(station_name)
    train_stops.each do |train_stop|
      if train_stop.train_station.to_s == station_name
        return "#{train_stop.actual_stop_time} [#{train_stop.status}]"
      end
    end
  end

  def last_stop
    return @train_stops[0].to_s if train_stops[0].status.to_s != StopState::DONE

    (train_stops.length - 1).times do |i|
      if train_stops[i].status.to_s == StopState::DONE && \
         train_stops[i + 1].status.to_s != StopState::DONE
        return train_stops[i].to_s
      end
    end

    train_stops[train_stops.length - 1].to_s
  end
end
