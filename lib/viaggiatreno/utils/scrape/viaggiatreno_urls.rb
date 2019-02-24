require_relative '../regex/regex_match_info'

# A class to build parametrized URL to scrape data from
class ViaggiatrenoURLs
  VIAGGIATRENO_URL = 'http://mobile.viaggiatreno.it/vt_pax_internet/mobile/'.freeze
  @site_station_info_url = (VIAGGIATRENO_URL + 'stazione').freeze
  class << self
    attr_accessor :site_station_info_url
  end
end
