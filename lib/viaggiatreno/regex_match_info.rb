class RegExpMatchInfo
  # regex to match train status (string)
  REGEXP_STATE_RUNNING = /(Il treno viaggia.*)(Ultimo rilevamento a)(.*)/
  REGEXP_STATE_NOT_STARTED = /Il treno non e' ancora partito/
  REGEXP_STATE_FINISHED = /Il treno e' arrivato.*/
  REGEXP_DELAY_STR = /con (\d+) minuti di ([anticipo|ritardo]+)/
  REGEXP_NODELAY_STR = /Il treno .* in orario.*/
  REGEXP_STOP_ALREADY_DONE = /giaeffettuate/
  STR_DELAY_STR = 'ritardo'
  STR_TRAIN_NUMBER_URL_REPLACE = 'TRAINNUMBER'
end
