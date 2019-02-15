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
    @outgoing_trains = []
    @incoming_trains = []
    @scraper.update
  end
end
