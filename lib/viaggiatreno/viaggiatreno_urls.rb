require_relative 'regex_match_info'

class ViaggiatrenoURLs
  SITE_INFO = 'http://mobile.viaggiatreno.it/vt_pax_internet/mobile/'
  SITE_INFO_MAIN =
    SITE_INFO + 'numero?numeroTreno=' +
    RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE + \
    '&tipoRicerca=numero&lang=IT'
  SITE_INFO_DETAILS =
    SITE_INFO +
    'scheda?dettaglio=visualizza&numeroTreno=' + \
    RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE + \
    '&tipoRicerca=numero&lang=IT'
end
