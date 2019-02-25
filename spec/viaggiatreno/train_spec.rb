require 'simplecov'
SimpleCov.start
require 'spec_helper'
require 'viaggia_treno'

describe Train do
  describe 'Arrived train (delay negative)' do
    before do
      VCR.use_cassette('Arrived train (delay negative)') do
        @train = Train.new('2570')
      end
    end

    it do
      expect(@train.train_name).to eq 'REG 2570'
      expect(@train.train_number).to eq '2570'
      expect(@train.state).to eq TrainState::ARRIVED
      expect(@train.delay).to eq(-3)
      expect(@train.status).to eq \
        'Il treno e\' arrivato con 3 minuti di anticipo'
      expect(@train.last_update).to eq nil
      expect(@train.last_stop.train_station).to eq 'LECCO'
      expect(@train.departing_station).to eq 'MILANO CENTRALE'
      expect(@train.arriving_station).to eq 'LECCO'
      expect(@train.scheduled_departing_time).to eq '17:50'
      expect(@train.scheduled_arriving_time).to eq '18:36'
      expect(@train.scheduled_departing_platform).to eq '2'
      expect(@train.scheduled_arriving_platform).to eq '3'
      expect(@train.actual_departing_time).to eq '17:50'
      expect(@train.actual_arriving_time).to eq '18:33' 
      expect(@train.actual_departing_platform).to eq nil
      expect(@train.actual_arriving_platform).to eq '3'
      expect(@train.scheduled_stop_time('CALOLZIOCORTE OLGINATE')).to eq '18:26'
      expect(@train.actual_stop_time('CALOLZIOCORTE OLGINATE')).to eq '18:25'
      expect(@train.stops.map(&:train_station)).to eq \
        ["MILANO CENTRALE", "MONZA", "CARNATE USMATE", "CERNUSCO-MERATE", "CALOLZIOCORTE OLGINATE", "LECCO"]
      expect(@train.stops.map(&:scheduled_stop_time)).to eq \
        ["17:50", "18:01", "18:10", "18:16", "18:26", "18:36"]
      expect(@train.stops.map(&:actual_stop_time)).to eq \
        ["17:50", "18:01", "18:10", nil, "18:25", "18:33"]
      expect(@train.stops.map(&:scheduled_platform)).to eq \
        ["2", "4", "2", "2", "3", "3"]
      expect(@train.stops.map(&:actual_platform)).to eq \
        [nil, "4", "2", "II", "3", "3"]
      expect(@train.stops.map(&:state)).to eq \
        [TrainStopState::DONE] * @train.stops.size
    end
  end

  describe 'Arrived train with duplicate train number (delay positive)' do
    before do
      VCR.use_cassette('Arrived train with duplicate train number (delay positive)') do
        @train = Train.new('11811')
      end
    end

    it do
      expect(@train.train_name).to eq 'REG 11811'
      expect(@train.train_number).to eq '11811'
      expect(@train.state).to eq TrainState::ARRIVED
      expect(@train.delay).to eq(4)
      expect(@train.status).to eq \
        'Il treno e\' arrivato con 4 minuti di ritardo'
      expect(@train.last_update).to eq nil
      expect(@train.last_stop.train_station).to eq 'FIRENZE S.M.N.'
      expect(@train.departing_station).to eq 'PRATO CENTRALE'
      expect(@train.arriving_station).to eq 'FIRENZE S.M.N.'
      expect(@train.scheduled_departing_time).to eq '21:12'
      expect(@train.scheduled_arriving_time).to eq '21:43'
      expect(@train.scheduled_departing_platform).to eq '4'
      expect(@train.scheduled_arriving_platform).to eq '6'
      expect(@train.actual_departing_time).to eq '21:15'
      expect(@train.actual_arriving_time).to eq '21:47'
      expect(@train.actual_departing_platform).to eq nil
      expect(@train.actual_arriving_platform).to eq '6'
      # TODO
      # expect { 
      #   @train.scheduled_stop_time('REGGIO EMILIA AV')
      # }.to raise_error
      # expect(@train.actual_stop_time('REGGIO EMILIA AV')).to eq nil
      expect(@train.scheduled_stop_time('IL NETO')).to eq '21:22'
      expect(@train.actual_stop_time('IL NETO')).to eq nil
      expect(@train.stops.map(&:train_station)).to eq \
        ["PRATO CENTRALE", "CALENZANO", "PRATIGNONE", "IL NETO", "SESTO FIORENTINO", "ZAMBRA", "FIRENZE CASTELLO", "FIRENZE RIFREDI", "FIRENZE S.M.N."]
      expect(@train.stops.map(&:scheduled_stop_time)).to eq \
        ["21:12", "21:15", "21:19", "21:22", "21:25", "21:28", "21:32", "21:37", "21:43"]
      expect(@train.stops.map(&:actual_stop_time)).to eq \
        ["21:15", nil, nil, nil, nil, nil, "21:31", "21:36", "21:47"]
      expect(@train.stops.map(&:scheduled_platform)).to eq \
        ["4", "3", "3", "3", "3", "3", "5", "5", "6"]
      expect(@train.stops.map(&:actual_platform)).to eq \
        [nil, "3", "3", "3", "3", "3", "5", "5", "6"]
      expect(@train.stops.map(&:state)).to eq \
        [TrainStopState::DONE] * @train.stops.size
    end
  end

  describe 'Arrived train with suppressed stops at the end' do
    before do
      VCR.use_cassette('Arrived train with suppressed stops at the end') do
        @train = Train.new('2550')
      end
    end

    it do
      expect(@train.train_name).to eq 'REG 2550'
      expect(@train.train_number).to eq '2550'
      expect(@train.state).to eq TrainState::ARRIVED
      expect(@train.delay).to eq(34)
      expect(@train.status).to eq \
        'Il treno e\' arrivato con 34 minuti di ritardo. Treno cancellato da SONDRIO a TIRANO. Arriva a SONDRIO'
      expect(@train.last_update).to eq nil
      expect(@train.last_stop.train_station).to eq 'SONDRIO'
      expect(@train.departing_station).to eq 'MILANO CENTRALE'
      expect(@train.arriving_station).to eq 'SONDRIO'
      expect(@train.scheduled_departing_time).to eq '06:20'
      expect(@train.scheduled_arriving_time).to eq '08:52'
      expect(@train.scheduled_departing_platform).to eq '5'
      expect(@train.scheduled_arriving_platform).to eq nil
      expect(@train.actual_departing_time).to eq '06:58'
      expect(@train.actual_arriving_time).to eq nil
      expect(@train.actual_departing_platform).to eq nil
      expect(@train.actual_arriving_platform).to eq nil
      expect(@train.scheduled_stop_time('COLICO')).to eq '07:47'
      expect(@train.actual_stop_time('COLICO')).to eq '08:24'
      expect(@train.stops.map(&:train_station)).to eq \
        ["MILANO CENTRALE", "MONZA", "LECCO", "VARENNA ESINO", "BELLANO TARTAVELLE TERME", "COLICO", "MORBEGNO", "SONDRIO", "TRESENDA-APRICA-TEGLIO", "TIRANO"]
      expect(@train.stops.map(&:scheduled_stop_time)).to eq \
        ["06:20", "06:31", "06:59", "07:23", "07:28", "07:47", "07:59", "08:20", "08:40", "08:52"]
      expect(@train.stops.map(&:actual_stop_time)).to eq \
        ["06:58", "07:08", "07:30", "08:00", "08:05", "08:24", "08:36", "08:54", nil, nil]
      expect(@train.stops.map(&:scheduled_platform)).to eq \
        ["5", "4", "3", "2", "1", "1", "1", "1", nil, nil]
      expect(@train.stops.map(&:actual_platform)).to eq \
        [nil, "4", "3", "2", "2", "1", "1", "2", nil, nil]
      expect(@train.stops.map(&:state)).to eq \
        ["DONE", "DONE", "DONE", "DONE", "DONE", "DONE", "DONE", "DONE", "SUPPRESSED", "SUPPRESSED"]
    end
  end

  describe 'Traveling train (delay negative)' do
    before do
      VCR.use_cassette('Traveling train (delay negative)') do
        @train = Train.new('35553')
      end
    end

    it do
      expect(@train.train_name).to eq 'IC 35553'
      expect(@train.train_number).to eq '35553'
      expect(@train.state).to eq TrainState::TRAVELING
      expect(@train.delay).to eq(-1)
      expect(@train.status).to eq \
        'Il treno viaggia con 1 minuti di anticipo'
      expect(@train.last_update).to eq 'Ultimo rilevamento a MINTURNO alle ore 22:50'
      expect(@train.last_stop.train_station).to eq 'FORMIA-GAETA'
      expect(@train.departing_station).to eq 'ROMA TERMINI'
      expect(@train.arriving_station).to eq 'SIRACUSA'
      expect(@train.scheduled_departing_time).to eq '21:31'
      expect(@train.scheduled_arriving_time).to eq '09:36'
      expect(@train.scheduled_departing_platform).to eq nil
      expect(@train.scheduled_arriving_platform).to eq nil
      expect(@train.actual_departing_time).to eq '21:33'
      expect(@train.actual_arriving_time).to eq '09:36'
      expect(@train.actual_departing_platform).to eq nil
      expect(@train.actual_arriving_platform).to eq nil
      expect(@train.scheduled_stop_time('LATINA')).to eq '22:05'
      expect(@train.actual_stop_time('LATINA')).to eq '22:04'
      expect(@train.stops.map(&:train_station)).to eq \
        ["ROMA TERMINI", "LATINA", "FORMIA-GAETA", "NAPOLI CENTRALE", "SALERNO", "VILLA SAN GIOVANNI", "MESSINA CENTRALE", "TAORMINA", "GIARRE RIPOSTO", "ACIREALE", "CATANIA CENTRALE", "LENTINI", "AUGUSTA", "SIRACUSA"]
      expect(@train.stops.map(&:scheduled_stop_time)).to eq \
        ["21:31", "22:05", "22:42", "23:59", "00:52", "04:25", "06:10", "07:29", "07:46", "08:01", "08:17", "08:50", "09:11", "09:36"]
      expect(@train.stops.map(&:actual_stop_time)).to eq \
        ["21:33", "22:04", "22:42", "23:59", "00:52", "04:25", "06:10", "07:29", "07:46", "08:01", "08:17", "08:50", "09:11", "09:36"]
      expect(@train.stops.map(&:scheduled_platform)).to eq \
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      expect(@train.stops.map(&:actual_platform)).to eq \
        [nil, "2", "4", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      expect(@train.stops.map(&:state)).to eq \
        [TrainStopState::DONE] * 3 + [TrainStopState::TO_BE_DONE] * (@train.stops.size - 3)
    end
  end

  describe 'Traveling train (delay positive)' do
    before do
      VCR.use_cassette('Traveling train (delay positive)') do
        @train = Train.new('9562')
        @train.update # testing a forced update
      end
    end

    it do
      expect(@train.train_name).to eq 'ES* 9562'
      expect(@train.train_number).to eq '9562'
      expect(@train.state).to eq TrainState::TRAVELING
      expect(@train.delay).to eq(18)
      expect(@train.status).to eq \
        'Il treno viaggia con 18 minuti di ritardo'
      expect(@train.last_update).to eq 'Ultimo rilevamento a PC Melegnano alle ore 22:46'
      expect(@train.last_stop.train_station).to eq 'REGGIO EMILIA AV'
      expect(@train.departing_station).to eq 'SALERNO'
      expect(@train.arriving_station).to eq 'MILANO CENTRALE'
      expect(@train.scheduled_departing_time).to eq '17:07'
      expect(@train.scheduled_arriving_time).to eq '22:45'
      expect(@train.scheduled_departing_platform).to eq '1'
      expect(@train.scheduled_arriving_platform).to eq '13'
      expect(@train.actual_departing_time).to eq '17:19'
      expect(@train.actual_arriving_time).to eq '23:03'
      expect(@train.actual_departing_platform).to eq nil
      expect(@train.actual_arriving_platform).to eq nil
      expect(@train.scheduled_stop_time('REGGIO EMILIA AV')).to eq '21:57'
      expect(@train.actual_stop_time('REGGIO EMILIA AV')).to eq '22:11'
      expect(@train.stops.map(&:train_station)).to eq \
        ["SALERNO", "NAPOLI CENTRALE", "NAPOLI AFRAGOLA", "ROMA TERMINI", "ROMA TIBURTINA", "FIRENZE S.M.N.", "BOLOGNA C.LE/AV", "REGGIO EMILIA AV", "MILANO CENTRALE"]
      expect(@train.stops.map(&:scheduled_stop_time)).to eq \
        ["17:07", "17:45", "18:09", "19:08", "19:27", "20:51", "21:35", "21:57", "22:45"]
      expect(@train.stops.map(&:actual_stop_time)).to eq \
        ["17:19", "17:45", "18:12", "19:22", "19:42", "21:06", "21:48", "22:11", "23:03"]
      expect(@train.stops.map(&:scheduled_platform)).to eq \
        ["1", "17", "1", "5", "12", "10", "16", "1", "13"]
      expect(@train.stops.map(&:actual_platform)).to eq \
        [nil, "18", "1", "6", "12", "10", "16", "1", nil]
      expect(@train.stops.map(&:state)).to eq \
        [TrainStopState::DONE] * (@train.stops.size - 1) + [TrainStopState::TO_BE_DONE]
    end
  end

  describe 'Traveling train (delay = 0)' do
    before do
      VCR.use_cassette('Traveling train (delay = 0)') do
        @train = Train.new('1174')
        @train.update
      end
    end

    it do
      expect(@train.train_name).to eq 'REG 1174'
      expect(@train.train_number).to eq '1174'
      expect(@train.state).to eq TrainState::TRAVELING
      expect(@train.delay).to eq(0)
      expect(@train.status).to eq \
        'Il treno viaggia in orario'
      expect(@train.last_update).to eq 'Ultimo rilevamento a CADORAGO alle ore 19:09'
      expect(@train.last_stop.train_station).to eq 'CADORAGO'
      expect(@train.departing_station).to eq 'COMO NORD LAGO'
      expect(@train.arriving_station).to eq 'M N CADORNA'
      expect(@train.scheduled_departing_time).to eq '18:46'
      expect(@train.scheduled_arriving_time).to eq '19:47'
      expect(@train.scheduled_departing_platform).to eq nil
      expect(@train.scheduled_arriving_platform).to eq nil
      expect(@train.actual_departing_time).to eq '18:47'
      expect(@train.actual_arriving_time).to eq '19:47'
      expect(@train.actual_departing_platform).to eq nil
      expect(@train.actual_arriving_platform).to eq nil
      expect(@train.scheduled_stop_time('GRANDATE - BRECCIA')).to eq '18:59'
      expect(@train.actual_stop_time('GRANDATE - BRECCIA')).to eq '18:59'
      expect(@train.stops.map(&:train_station)).to eq \
        ["COMO NORD LAGO", "COMO NORD BORGHI", "COMO NORD CAMERLATA", "GRANDATE - BRECCIA", "PORTICHETTO - LUISAGO", "FINO MORNASCO", "CADORAGO", "CASLINO AL PIANO", "LOMAZZO", "ROVELLASCA - MANERA", "ROVELLO PORRO", "SARONNO", "MILANO BOVISA", "MILANO NORD DOMODOSSOLA", "M N CADORNA"]
      expect(@train.stops.map(&:scheduled_stop_time)).to eq \
        ["18:46", "18:49", "18:55", "18:59", "19:03", "19:06", "19:09", "19:12", "19:14", "19:19", "19:21", "19:26", "19:39", "19:43", "19:47"]
      expect(@train.stops.map(&:actual_stop_time)).to eq \
        ["18:47", "18:49", "18:56", "18:59", "19:03", "19:06", "19:09", "19:12", "19:14", "19:19", "19:21", "19:26", "19:39", "19:43", "19:47"]
      expect(@train.stops.map(&:scheduled_platform)).to eq \
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      expect(@train.stops.map(&:actual_platform)).to eq \
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      expect(@train.stops.map(&:state)).to eq \
        [TrainStopState::DONE] * 7 + [TrainStopState::TO_BE_DONE] * (@train.stops.size - 7)
    end
  end

  describe 'Not departed train' do
    before do
      VCR.use_cassette('Not departed train') do
        @train = Train.new('12299')
      end
    end
    it do
      expect(@train.train_name).to eq 'REG 12299'
      expect(@train.train_number).to eq '12299'
      expect(@train.state).to eq TrainState::NOT_DEPARTED
      expect(@train.delay).to eq nil
      expect(@train.status).to eq \
        'Il treno non e\' ancora partito'
      expect(@train.last_update).to eq nil
      expect(@train.last_stop).to eq nil
      expect(@train.departing_station).to eq 'ROMA TERMINI'
      expect(@train.arriving_station).to eq 'PRIVERNO FOSSANOVA'
      expect(@train.scheduled_departing_time).to eq '23:06'
      expect(@train.scheduled_arriving_time).to eq '00:06'
      expect(@train.scheduled_departing_platform).to eq '10'
      expect(@train.scheduled_arriving_platform).to eq '4'
      expect(@train.actual_departing_time).to eq nil
      expect(@train.actual_arriving_time).to eq nil
      expect(@train.actual_departing_platform).to eq nil
      expect(@train.actual_arriving_platform).to eq nil
      expect(@train.scheduled_stop_time('LATINA')).to eq '23:48'
      expect(@train.actual_stop_time('LATINA')).to eq nil
      expect(@train.stops.map(&:train_station)).to eq \
        ["ROMA TERMINI", "TORRICOLA", "POMEZIA - S.PALOMBA", "CAMPOLEONE", "CISTERNA DI LATINA", "LATINA", "SEZZE ROMANO", "PRIVERNO FOSSANOVA"]
      expect(@train.stops.map(&:scheduled_stop_time)).to eq \
        ["23:06", "23:16", "23:24", "23:31", "23:40", "23:48", "23:56", "00:06"]
      expect(@train.stops.map(&:actual_stop_time)).to eq \
        [nil, nil, nil, nil, nil, nil, nil, nil]
      expect(@train.stops.map(&:scheduled_platform)).to eq \
        ["10", "2", "1", "2", "1", "2", "3", "4"]
      expect(@train.stops.map(&:actual_platform)).to eq \
        [nil, nil, nil, nil, nil, nil, nil, nil]
      expect(@train.stops.map(&:state)).to eq \
        [TrainStopState::TO_BE_DONE] * @train.stops.size
    end
  end

  describe 'Not departed train with suppressed stops' do
    before do
      VCR.use_cassette('Not departed train with suppressed stops') do
        @train = Train.new('23076')
      end
    end
    it do
      expect(@train.train_name).to eq 'REG 23076'
      expect(@train.train_number).to eq '23076'
      expect(@train.state).to eq TrainState::NOT_DEPARTED
      expect(@train.delay).to eq nil
      expect(@train.status).to eq \
        'Il treno non e\' ancora partito. Treno cancellato da TREVIGLIO a MILANO CERTOSA. Parte da MILANO CERTOSA.'
      expect(@train.last_update).to eq nil
      expect(@train.last_stop).to eq nil
      expect(@train.departing_station).to eq 'MILANO CERTOSA'
      expect(@train.arriving_station).to eq 'GALLARATE'
      expect(@train.scheduled_departing_time).to eq '21:12'
      expect(@train.scheduled_arriving_time).to eq '21:51'
      expect(@train.scheduled_departing_platform).to eq '6'
      expect(@train.scheduled_arriving_platform).to eq '3'
      expect(@train.actual_departing_time).to eq nil
      expect(@train.actual_arriving_time).to eq nil
      expect(@train.actual_departing_platform).to eq nil
      expect(@train.actual_arriving_platform).to eq nil
      expect(@train.scheduled_stop_time('TRECELLA')).to eq '20:20'
      expect(@train.actual_stop_time('TRECELLA')).to eq nil
      expect(@train.find_stop('TRECELLA').state).to eq 'SUPPRESSED' 
      expect(@train.stops.map(&:train_station)).to eq \
        ["TREVIGLIO", "CASSANO D`ADDA", "TRECELLA", "POZZUOLO MARTESANA", "MELZO", "VIGNATE", "PIOLTELLO LIMITO", "SEGRATE", "MILANO FORLANINI", "MILANO PORTA VITTORIA", "MILANO DATEO", "MILANO VENEZIA", "MILANO REPUBBLICA", "MI P.GAR.SOTT.", "MILANO LANCETTI", "MILANO VILLAPIZZONE", "MILANO CERTOSA", "RHO FIERA MILANO", "RHO", "VANZAGO POGLIANO", "PARABIAGO", "CANEGRATE", "LEGNANO", "BUSTO ARSIZIO", "GALLARATE"]
      expect(@train.stops.map(&:scheduled_stop_time)).to eq \
      ["20:10", "20:16", "20:20", "20:24", "20:28", "20:32", "20:37", "20:41", "20:47", "20:52", "20:54", "20:56", "20:58", "21:01", "21:05", "21:08", "21:12", "21:16", "21:23", "21:27", "21:32", "21:35", "21:39", "21:44", "21:51"]
      expect(@train.stops.map(&:actual_stop_time)).to eq \
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      expect(@train.stops.map(&:scheduled_platform)).to eq \
        ["6", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "6", "1", "2", "2", "3", "2", "3", "4", "3"]
      expect(@train.stops.map(&:actual_platform)).to eq \
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
      expect(@train.stops.map(&:state)).to eq \
        ["SUPPRESSED"] * 16 + ["TO BE DONE"] * 9
      end
  end

  describe 'Not existent train' do
    before do
      VCR.use_cassette('Not existent train') do
        @train = Train.new('10101001010101100')
      end
    end
    it do
      expect(@train.train_number).to eq nil
      end
  end
end
