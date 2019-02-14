require_relative '../regex/regex_match_info'

# A class to build parametrized URL to scrape data from
class ViaggiatrenoURLs
  VIAGGIATRENO_URL = 'http://mobile.viaggiatreno.it/vt_pax_internet/mobile/'.freeze
  @SITE_STATION_INFO_URL = (VIAGGIATRENO_URL + 'stazione').freeze
  class << self
    attr_accessor :SITE_STATION_INFO_URL
  end

  def self.get_train_info_url(train_number)
    VIAGGIATRENO_URL + 'numero?numeroTreno=' +
      train_number +
      '&tipoRicerca=numero&lang=IT'
  end

  def self.get_train_info_details_url(train_number)
    VIAGGIATRENO_URL +
      'scheda?dettaglio=visualizza&numeroTreno=' +
      train_number +
      '&tipoRicerca=numero&lang=IT'
  end
end
