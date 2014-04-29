class XPathMatchInfo
    # xpath expression to retrieve train info
	@@XPATH_STATUS = '//div[@class="evidenziato"]/strong'
	@@XPATH_TRAIN_NAME = '//h1/text()'
	@@XPATH_DETAILS_GENERIC = 
	    '//div[@class="giaeffettuate"] | //div[@class="corpocentrale"]'
	@@XPATH_DETAILS_STATION_NAME = 'h2/text()'
	@@XPATH_DETAILS_SCHEDULED_STOP_TIME = 'p[1]/strong[1]/text()'
	@@XPATH_DETAILS_ACTUAL_STOP_TIME = 'p[2]/strong[1]/text()'
	@@XPATH_STATION='//div[@class="bloccorisultato"]/div[contains(.,"Per ")]/..'

	@@XPATH_TRAIN_NUMBER='h2/text()'
	@@XPATH_TRAIN_DESTINATION='div/strong[1]/text()'
	@@XPATH_TRAIN_SCHEDULED='div/strong[2]/text()'



	def self.XPATH_STATUS() @@XPATH_STATUS end
	def self.XPATH_TRAIN_NAME() @@XPATH_TRAIN_NAME end
	def self.XPATH_DETAILS_GENERIC() @@XPATH_DETAILS_GENERIC end
	def self.XPATH_DETAILS_STATION_NAME() @@XPATH_DETAILS_STATION_NAME end
	def self.XPATH_DETAILS_SCHEDULED_STOP_TIME() 
	     @@XPATH_DETAILS_SCHEDULED_STOP_TIME end
	def self.XPATH_DETAILS_ACTUAL_STOP_TIME() @@XPATH_DETAILS_ACTUAL_STOP_TIME end
	
	def self.XPATH_STATION() @@XPATH_STATION end
	def self.XPATH_TRAIN_NUMBER() @@XPATH_TRAIN_NUMBER end
	def self.XPATH_TRAIN_DESTINATION() @@XPATH_TRAIN_DESTINATION end
	def self.XPATH_TRAIN_SCHEDULED() @@XPATH_TRAIN_SCHEDULED end
end

