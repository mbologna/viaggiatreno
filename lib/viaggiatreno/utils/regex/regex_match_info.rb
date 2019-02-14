class RegExpMatchInfo
  # regex to match train status (string)
  REGEXP_STATE_TRAVELING =
    /(Il treno viaggia.*)(Ultimo rilevamento a)(.*)/.freeze
  REGEXP_STATE_NOT_DEPARTED = /Il treno non e' ancora partito/.freeze
  REGEXP_STATE_ARRIVED = /Il treno e' arrivato.*/.freeze
  REGEXP_DELAY_STR = /con (\d+) minuti di ([anticipo|ritardo]+)/.freeze
  REGEXP_NODELAY_STR = /Il treno .* in orario.*/.freeze
  REGEXP_STOP_ALREADY_DONE = /giaeffettuate/.freeze
  REGEXP_SCHEDULED_RAIL = /Binario Previsto: (\d+|--)/.freeze
  REGEXP_ACTUAL_RAIL = /Binario Reale: (\d+|--)/.freeze
  STR_DELAY_STR = 'ritardo'.freeze
end
