require_relative '../regex/regex_match_info'

class ViaggiatrenoURLs
  VIAGGIATRENO_URL = 'http://mobile.viaggiatreno.it/vt_pax_internet/mobile/'.freeze
  SITE_TRAIN_INFO_STATUS =
    VIAGGIATRENO_URL + 'numero?numeroTreno=' +
    RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE +
    '&tipoRicerca=numero&lang=IT'
  SITE_TRAIN_INFO_DETAILS =
    SITE_TRAIN_INFO_STATUS +
    'scheda?dettaglio=visualizza&numeroTreno=' +
    RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE +
    '&tipoRicerca=numero&lang=IT'
  SITE_STATION_INFO = VIAGGIATRENO_URL + 'stazione'
end
