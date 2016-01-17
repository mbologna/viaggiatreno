require 'spec_helper'
require 'viaggia_treno'

describe Train do
  describe 'Arrived train (delay negative)' do
    before do
      VCR.use_cassette('Arrived train (delay negative)') do
        @train = Train.new('2550')
        @train.update_details
      end
    end

    it do
      expect(@train.to_s).to eq \
        '2550 REG 2550: Il treno e\' arrivato con 2 minuti di anticipo state'\
        ': ARRIVED,     delay: -2, last_update: '
      expect(@train.state).to eq TrainState::ARRIVED
      expect(@train.delay).to eq(-2)
      expect(@train.train_number).to eq '2550'
      expect(@train.train_name).to eq 'REG 2550'
      expect(@train.status).to eq 'Il treno e\' arrivato con 2 minuti di anticipo'
      expect(@train.last_update).to eq nil
      expect(@train.last_stop).to eq '[X] TIRANO = SCHEDULED: 08:52 ACTUAL: 08:50'
      expect(@train.departing_station).to eq 'MILANO CENTRALE'
      expect(@train.arriving_station).to eq 'TIRANO'
      expect(@train.scheduled_departing_time).to eq '06:20'
      expect(@train.actual_departing_time).to eq '06:20'
      expect(@train.scheduled_arriving_time).to eq '08:52'
      expect(@train.actual_arriving_time).to eq '08:50'
      expect(@train.scheduled_stop_time('COLICO')).to eq '07:47 [DONE]'
      expect(@train.actual_stop_time('COLICO')).to eq '07:49 [DONE]'
      expect(@train.train_stops.map(&:to_s)).to eq \
        [
          '[X] MILANO CENTRALE = SCHEDULED: 06:20 ACTUAL: 06:20',
          '[X] MONZA = SCHEDULED: 06:31 ACTUAL: 06:32',
          '[X] LECCO = SCHEDULED: 06:59 ACTUAL: 06:55',
          '[X] VARENNA ESINO = SCHEDULED: 07:23 ACTUAL: 07:23',
          '[X] BELLANO TARTAVELLE TERME = SCHEDULED: 07:28 ACTUAL: 07:29',
          '[X] COLICO = SCHEDULED: 07:47 ACTUAL: 07:49',
          '[X] MORBEGNO = SCHEDULED: 07:59 ACTUAL: 08:01',
          '[X] SONDRIO = SCHEDULED: 08:20 ACTUAL: 08:20',
          '[X] TRESENDA-APRICA-TEGLIO = SCHEDULED: 08:40 ACTUAL: 08:37',
          '[X] TIRANO = SCHEDULED: 08:52 ACTUAL: 08:50'
        ]
    end
  end

  describe 'Arrived train (delay = 0)' do
    before do
      VCR.use_cassette('Arrived train (delay = 0)') do
        @train = Train.new('3961')
        @train.update_details
      end
    end

    it do
      expect(@train.to_s).to eq \
        '3961 REG 3961: Il treno e\' arrivato in orario state: ARRIVED,     delay: 0, last_update: '
      expect(@train.state).to eq TrainState::ARRIVED
      expect(@train.delay).to eq 0
      expect(@train.train_number).to eq '3961'
      expect(@train.train_name).to eq 'REG 3961'
      expect(@train.status).to eq 'Il treno e\' arrivato in orario'
      expect(@train.last_update).to eq nil
      expect(@train.last_stop).to eq '[X] ALESSANDRIA = SCHEDULED: 09:48 ACTUAL: 09:48'
      expect(@train.departing_station).to eq 'MILANO CENTRALE'
      expect(@train.arriving_station).to eq 'ALESSANDRIA'
      expect(@train.scheduled_departing_time).to eq '08:25'
      expect(@train.actual_departing_time).to eq '08:27'
      expect(@train.scheduled_arriving_time).to eq '09:48'
      expect(@train.actual_arriving_time).to eq '09:48'
      expect(@train.scheduled_stop_time('TORTONA')).to eq '09:27 [DONE]'
      expect(@train.actual_stop_time('TORTONA')).to eq '09:27 [DONE]'
    end
  end

  describe 'Arrived train (delay positive)' do
    before do
      VCR.use_cassette('Arrived train (delay positive)') do
        @train = Train.new('2109')
        @train.update_details
      end
    end

    it do
      expect(@train.to_s).to eq \
        '2109 REG 2109: Il treno e\' arrivato con 3 minuti di ritardo state: '\
        'ARRIVED,     delay: 3, last_update: '
      expect(@train.state).to eq TrainState::ARRIVED
      expect(@train.delay).to eq 3
      expect(@train.train_number).to eq '2109'
      expect(@train.train_name).to eq 'REG 2109'
      expect(@train.status).to eq 'Il treno e\' arrivato con 3 minuti di ritardo'
      expect(@train.last_update).to eq nil
      expect(@train.last_stop).to eq '[X] VERONA PORTA NUOVA = SCHEDULED: 20:20 ACTUAL: 20:23'
      expect(@train.departing_station).to eq 'MILANO CENTRALE'
      expect(@train.arriving_station).to eq 'VERONA PORTA NUOVA'
      expect(@train.scheduled_departing_time).to eq '18:25'
      expect(@train.actual_departing_time).to eq '18:29'
      expect(@train.scheduled_arriving_time).to eq '20:20'
      expect(@train.actual_arriving_time).to eq '20:23'
      expect(@train.scheduled_stop_time('DESENZANO')).to eq '19:50 [DONE]'
      expect(@train.actual_stop_time('DESENZANO')).to eq '19:57 [DONE]'
    end
  end

  describe 'Running train (delay positive)' do
    before do
      VCR.use_cassette('Running train (delay positive)') do
        @train = Train.new('2655')
        @train.update_details
      end
    end

    it do
      expect(@train.to_s).to eq \
        '2655 REG 2655: Il treno viaggia con 1 minuti di ritardo state: '\
        'TRAVELING,     delay: 1, last_update: MILANO LAMBRATE alle ore 14:28'
      expect(@train.state).to eq TrainState::TRAVELING
      expect(@train.delay).to eq 1
      expect(@train.train_number).to eq '2655'
      expect(@train.train_name).to eq 'REG 2655'
      expect(@train.status).to eq 'Il treno viaggia con 1 minuti di ritardo'
      expect(@train.last_update).to eq 'MILANO LAMBRATE alle ore 14:28'
      expect(@train.last_stop).to eq '[X] MILANO LAMBRATE = SCHEDULED: 14:26 ACTUAL: 14:25'
      expect(@train.departing_station).to eq 'MILANO CENTRALE'
      expect(@train.arriving_station).to eq 'MANTOVA'
      expect(@train.scheduled_departing_time).to eq '14:20'
      expect(@train.actual_departing_time).to eq '14:21'
      expect(@train.scheduled_arriving_time).to eq '16:10'
      expect(@train.actual_arriving_time).to eq '16:11'
      expect(@train.scheduled_stop_time('PIADENA')).to eq '15:46 [TODO]'
      expect(@train.actual_stop_time('PIADENA')).to eq '15:47 [TODO]'
      expect(@train.train_stops.map(&:to_s)).to eq \
        [
          '[X] MILANO CENTRALE = SCHEDULED: 14:20 ACTUAL: 14:21',
          '[X] MILANO LAMBRATE = SCHEDULED: 14:26 ACTUAL: 14:25',
          '[ ] MILANO ROGOREDO = SCHEDULED: 14:31 EXPECTED: 14:32',
          '[ ] LODI = SCHEDULED: 14:46 EXPECTED: 14:47',
          '[ ] CODOGNO = SCHEDULED: 15:01 EXPECTED: 15:02',
          '[ ] PONTE D`ADDA = SCHEDULED: 15:11 EXPECTED: 15:12',
          '[ ] CREMONA = SCHEDULED: 15:28 EXPECTED: 15:29',
          '[ ] PIADENA = SCHEDULED: 15:46 EXPECTED: 15:47',
          '[ ] MANTOVA = SCHEDULED: 16:10 EXPECTED: 16:11'
        ]
    end
  end

  describe 'Not departed train' do
    before do
      VCR.use_cassette('Not departed train') do
        @train = Train.new('2657')
        @train.update_details
      end
    end

    it do
      expect(@train.to_s).to eq \
        '2657 REG 2657: Il treno non e\' ancora partito state: '\
        'NOT DEPARTED,     delay: , last_update: '
      expect(@train.state).to eq TrainState::NOT_DEPARTED
      expect(@train.delay).to eq nil
      expect(@train.train_number).to eq '2657'
      expect(@train.train_name).to eq 'REG 2657'
      expect(@train.status).to eq 'Il treno non e\' ancora partito'
      expect(@train.last_update).to eq nil
      expect(@train.last_stop).to eq '[X] MILANO CENTRALE = SCHEDULED: 16:20 ACTUAL: '
      expect(@train.departing_station).to eq 'MILANO CENTRALE'
      expect(@train.arriving_station).to eq 'MANTOVA'
      expect(@train.scheduled_departing_time).to eq '16:20'
      expect(@train.actual_departing_time).to eq ''
      expect(@train.scheduled_arriving_time).to eq '18:10'
      expect(@train.actual_arriving_time).to eq '18:10'
      expect(@train.scheduled_stop_time('LODI')).to eq '16:46 [TODO]'
      expect(@train.actual_stop_time('LODI')).to eq '16:46 [TODO]'
      expect(@train.train_stops.map(&:to_s)).to eq \
        [
          '[X] MILANO CENTRALE = SCHEDULED: 16:20 ACTUAL: ',
          '[ ] MILANO LAMBRATE = SCHEDULED: 16:26 EXPECTED: 16:26',
          '[ ] MILANO ROGOREDO = SCHEDULED: 16:31 EXPECTED: 16:31',
          '[ ] LODI = SCHEDULED: 16:46 EXPECTED: 16:46',
          '[ ] CODOGNO = SCHEDULED: 17:01 EXPECTED: 17:01',
          '[ ] PONTE D`ADDA = SCHEDULED: 17:11 EXPECTED: 17:11',
          '[ ] CREMONA = SCHEDULED: 17:28 EXPECTED: 17:28',
          '[ ] PIADENA = SCHEDULED: 17:46 EXPECTED: 17:46',
          '[ ] MANTOVA = SCHEDULED: 18:10 EXPECTED: 18:10'
        ]
    end
  end
end
