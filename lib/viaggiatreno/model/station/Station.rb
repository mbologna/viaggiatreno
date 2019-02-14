require_relative 'ScraperStation.rb'

class Station
	attr_accessor :trains, :stationFrom, :stationTo, :destinations
	
def initialize(stationFrom, stationTo = nil)
	@stationFrom = stationFrom.upcase
	@stationTo = stationTo.upcase if stationTo
	@scraper = ScraperStation.new(@stationFrom,@stationTo)
	@trains = Hash.new()
	@destinations = Array.new()
end

	def update()
		@scraper.updateStation()
		@trains=@scraper.trains
		@destinations=@scraper.destinations.uniq
	end

def to_s
	retval=""
	@trains.each do |k,v|
		retval += "#{v}\n"
	end
	return retval
end


end