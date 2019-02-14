require 'viaggiatreno/utils/scrape/scraper'

# Model class to represent a train station
class Station
  attr_accessor :station_name, :outgoing_trains, :incoming_trains

  def initialize(station_name)
    @station_name = station_name
    @outgoing_trains = []
    @incoming_trains = []
    @scraper = StationScraper.new(station_name, self)
    update
  end

  def update
    @scraper.update
  end

  def to_s
    puts 'Outgoing: '
    @outgoing_trains.each do |train|
      puts train.train_number
      puts train.find_stop_time(@station_name)
      puts train.train_stops.last.train_station
    end

    puts 'Incoming: '
    @incoming_trains.each do |train|
      puts train.train_number
      puts train.find_stop_time(@station_name)
      puts train.train_stops.first.train_station
    end
  end
end
