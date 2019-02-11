class XPathMatchInfo
  # xpath expression to retrieve train info
  XPATH_STATUS = '//div[@class="evidenziato"]/strong'.freeze
  XPATH_TRAIN_NAME = '//h1/text()'.freeze
  XPATH_TRAIN_GENERIC_INFO = '//div[@class="corpocentrale"]'.freeze
  XPATH_DETAILS_GENERIC =
    '//div[@class="giaeffettuate"] | //div[@class="corpocentrale"]'.freeze
  XPATH_DETAILS_STATION_NAME = 'h2/text()'.freeze
  XPATH_DETAILS_SCHEDULED_STOP_TIME = 'p[1]/strong[1]/text()'.freeze
  XPATH_DETAILS_ACTUAL_STOP_TIME = 'p[2]/strong[1]/text()'.freeze
end
