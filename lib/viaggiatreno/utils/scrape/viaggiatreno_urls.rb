require_relative '../regex/regex_match_info'

class ViaggiatrenoURLs
  VIAGGIATRENO_URL = 'http://mobile.viaggiatreno.it/vt_pax_internet/mobile/'.freeze
  SITE_STATION_INFO = (VIAGGIATRENO_URL + 'stazione').freeze

  def self.getTrainInfoURL(train_number)
    return VIAGGIATRENO_URL + 'numero?numeroTreno=' +
    train_number +
    '&tipoRicerca=numero&lang=IT'
  end

  def self.getTrainInfoDetailsURL(train_number)
    return VIAGGIATRENO_URL +
    'scheda?dettaglio=visualizza&numeroTreno=' +
    train_number +
    '&tipoRicerca=numero&lang=IT'
  end
end
