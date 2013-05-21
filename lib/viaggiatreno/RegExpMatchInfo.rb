class RegExpMatchInfo

  # regex to match train status (string)
  @@REGEXP_STATE_RUNNING = /(Il treno viaggia.*)(Ultimo rilevamento a)(.*)/
  @@REGEXP_STATE_NOT_STARTED = /Il treno non e' ancora partito/
  @@REGEXP_STATE_FINISHED = /Il treno e' arrivato.*/
  @@REGEXP_DELAY_STR = /con (\d+) minuti di ([anticipo|ritardo]+)/
  @@REGEXP_NODELAY_STR = /Il treno .* in orario.*/
  @@REGEXP_STOP_ALREADY_DONE = /giaeffettuate/
  @@STR_DELAY_STR = "ritardo"
  @@STR_TRAIN_NUMBER_URL_REPLACE = "TRAINNUMBER"

  # attr_reader for class variables
  def self.REGEXP_STATE_FINISHED() @@REGEXPSTATE_FINISHED end
  def self.REGEXP_STATE_RUNNING() @@REGEXP_STATE_RUNNING end
  def self.REGEXP_STATE_NOT_STARTED() @@REGEXP_STATE_NOT_STARTED end
  def self.REGEXP_STATE_FINISHED() @@REGEXP_STATE_FINISHED end
  def self.STR_DELAY_STR() @@STR_DELAY_STR end
  def self.REGEXP_DELAY_STR() @@REGEXP_DELAY_STR end
  def self.REGEXP_NODELAY_STR() @@REGEXP_NODELAY_STR end
  def self.REGEXP_STOP_ALREADY_DONE() @@REGEXP_STOP_ALREADY_DONE end
  def self.STR_TRAIN_NUMBER_URL_REPLACE() @@STR_TRAIN_NUMBER_URL_REPLACE end
end
