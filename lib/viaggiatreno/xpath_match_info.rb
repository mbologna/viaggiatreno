class XPathMatchInfo
  # xpath expression to retrieve train info
  XPATH_STATUS = '//div[@class="evidenziato"]/strong'
  XPATH_TRAIN_NAME = '//h1/text()'
  XPATH_DETAILS_GENERIC =
      '//div[@class="giaeffettuate"] | //div[@class="corpocentrale"]'
  XPATH_DETAILS_STATION_NAME = 'h2/text()'
  XPATH_DETAILS_SCHEDULED_STOP_TIME = 'p[1]/strong[1]/text()'
  XPATH_DETAILS_ACTUAL_STOP_TIME = 'p[2]/strong[1]/text()'
end
