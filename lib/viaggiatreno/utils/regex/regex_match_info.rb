class RegExMatchInfo
  # regex to match train status (string)
  TRAIN_STATE_TRAVELING =
    /(Il treno viaggia.*)(Ultimo rilevamento a .*)/.freeze
  TRAIN_STATE_NOT_DEPARTED = /Il treno non e' ancora partito/.freeze
  TRAIN_STATE_ARRIVED = /Il treno e' arrivato.*/.freeze
  TRAIN_DELAY_STR = /con (\d+) minuti di ([anticipo|ritardo]+)/.freeze
  TRAIN_NODELAY_STR = /Il treno .* in orario.*/.freeze
  TRAIN_STOP_ALREADY_DONE = /giaeffettuate/.freeze
  TRAIN_STOP_PLATFORM =
    /Binario Previsto: ([a-zA-Z0-9 ]*).*Binario Reale: ([a-zA-Z0-9 ]*)/.freeze
  STATION_NAME = /Stazione di (.*)/
end
