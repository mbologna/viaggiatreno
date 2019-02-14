require 'net/http'
require 'nokogiri'
require_relative 'StringUtils'
require_relative 'RegExpMatchInfo'
require_relative 'XPathMatchInfo'
require_relative 'ViaggiatrenoURLs'

class ScraperStation
    attr_accessor :trains, :destinations

  def initialize(stationFrom,stationTo)
    @stationFrom = stationFrom
    @stationTo = stationTo   
    @trains = {}
    @destinations = []
  end

  # fetch and parse basic train information (status, trainName, details)
  def updateStation()
    uri=URI.parse(ViaggiatrenoURLs.STATION_INFO)
    response = Net::HTTP.post_form(uri,{"stazione" => @stationFrom, "lang" => "IT"})
    doc = Nokogiri::HTML(response.body)

    doc.xpath(XPathMatchInfo.XPATH_STATION).each do |x|
      
      StringUtils.remove_newlines_tabs_and_spaces(x)

      train_number_complete = x.xpath(XPathMatchInfo.XPATH_TRAIN_NUMBER()).to_s
      train_destination = x.xpath(XPathMatchInfo.XPATH_TRAIN_DESTINATION()).to_s
      train_schedule =x.xpath(XPathMatchInfo.XPATH_TRAIN_SCHEDULED()).to_s
      train_description = "#{train_number_complete} #{train_destination} #{train_schedule}"
      
      train_number=train_number_complete.match("[0-9]+")[0]
      
      @trains[train_number]=train_description
      @destinations.push(train_destination)
     ### TODO #### #@trains[train_number][description]=train_description
    end
   end
end

