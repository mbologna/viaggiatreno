require_relative 'regex_match_info'

class ViaggiatrenoURLs
  SITE_INFO_MAIN =
      'http://mobile.viaggiatreno.it/vt_pax_internet/mobile/numero?numeroTreno=' + \
      RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE + \
      '&tipoRicerca=numero&lang=IT'
  SITE_INFO_DETAILS =
      'http://mobile.viaggiatreno.it/vt_pax_internet/mobile/scheda?dettaglio=visualizza&numeroTreno=' + \
      RegExpMatchInfo::STR_TRAIN_NUMBER_URL_REPLACE + \
      '&tipoRicerca=numero&lang=IT'
end
