class XPathMatchInfo
  # xpath expression to retrieve train info
  SEARCH_ERROR = '//span[@class="errore"]/text()'.freeze
  TRAIN_STATUS = '//div[@class="evidenziato"]/strong/text()'.freeze
  TRAIN_EXTRAORDINARY_EVENT = '//div[@class="evidenziato"]/div/text()'.freeze
  TRAIN_NAME = '//h1/text()'.freeze
  TRAIN_DETAILS_GENERIC =
    '//div[@class="giaeffettuate"] | //div[@class="corpocentrale"]'.freeze
  TRAIN_DETAILS_STATION_NAME = 'h2/text()'.freeze
  TRAIN_DETAILS_SUPPRESSED_STOP = 'strong/font'.freeze
  TRAIN_DETAILS_SCHEDULED_STOP_TIME = './p[1]/strong[1]/text()'.freeze
  TRAIN_DETAILS_ACTUAL_STOP_TIME = './p[2]/strong[1]/text()'.freeze
  STATION_LIST = '//div[@class="corpocentrale" or @class="bloccorisultato"]'
  STATION_TRAIN_NUMBER = './/h2/text()'
  STATION_NAME = '//h1/text()'
end
