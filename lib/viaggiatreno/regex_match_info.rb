class RegExpMatchInfo
  # regex to match train status (string)
  REGEXP_STATE_TRAVELING = /(Il treno viaggia.*)(Ultimo rilevamento a)(.*)/
  REGEXP_STATE_NOT_DEPARTED = /Il treno non e' ancora partito/
  REGEXP_STATE_ARRIVED = /Il treno e' arrivato.*/
  REGEXP_DELAY_STR = /con (\d+) minuti di ([anticipo|ritardo]+)/
  REGEXP_NODELAY_STR = /Il treno .* in orario.*/
  REGEXP_STOP_ALREADY_DONE = /giaeffettuate/
  STR_DELAY_STR = 'ritardo'.freeze
  STR_TRAIN_NUMBER_URL_REPLACE = 'TRAINNUMBER'.freeze
end
