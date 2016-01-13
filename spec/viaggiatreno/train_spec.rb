require 'spec_helper'
require 'viaggia_treno'

describe Train do
  before do
    VCR.use_cassette('Train new') do
      @train = Train.new('20241')
    end
  end

  describe '#to_s' do
    it do
      expect(@train.to_s).to eq \
        '20241 REG 20241: Il treno e\' arrivato con 2 minuti di ritardo state'\
        ': ARRIVED,     delay: 2, last_update:  '
    end
  end

  describe '#trainStops' do
    before do
      VCR.use_cassette('Train train stops') do
        @train_stops = @train.train_stops
      end
    end

    it do
      expect(@train_stops.map(&:to_s)).to eq [
        '[X] DOMODOSSOLA = SCHEDULED: 18:10 EXPECTED: 18:11',
        '[X] VOGOGNA OSSOLA = SCHEDULED: 18:18 EXPECTED: 18:20',
        '[X] PREMOSELLO CHIOVENDA = SCHEDULED: 18:21 EXPECTED: 18:22',
        '[X] CUZZAGO = SCHEDULED: 18:25 EXPECTED: 18:27',
        '[X] MERGOZZO = SCHEDULED: 18:31 EXPECTED: 18:32',
        '[X] VERBANIA-PALLANZA = SCHEDULED: 18:35 EXPECTED: 18:36',
        '[X] BAVENO = SCHEDULED: 18:40 EXPECTED: 18:42',
        '[X] STRESA = SCHEDULED: 18:44 EXPECTED: 18:46',
        '[X] BELGIRATE = SCHEDULED: 18:49 EXPECTED: 18:53',
        '[X] LESA = SCHEDULED: 18:53 EXPECTED: 18:57',
        '[X] MEINA = SCHEDULED: 18:57 EXPECTED: 19:00',
        '[X] ARONA = SCHEDULED: 19:02 EXPECTED: 19:06',
        '[X] DORMELLETTO = SCHEDULED: 19:07 EXPECTED: 19:11',
        '[X] SESTO CALENDE = SCHEDULED: 19:12 EXPECTED: 19:16',
        '[X] VERGIATE = SCHEDULED: 19:17 EXPECTED: 19:21',
        '[X] SOMMA LOMBARDO = SCHEDULED: 19:21 EXPECTED: 19:25',
        '[X] CASORATE SEMPIONE = SCHEDULED: 19:25 EXPECTED: 19:30',
        '[X] GALLARATE = SCHEDULED: 19:32 EXPECTED: 19:33',
        '[X] BUSTO ARSIZIO = SCHEDULED: 19:38 EXPECTED: 19:39',
        '[X] RHO = SCHEDULED: 20:00 EXPECTED: 19:57',
        '[X] MILANO PORTA GARIBALDI = SCHEDULED: 20:13 EXPECTED: 20:15'
      ]
    end
  end

  describe '#departingStation' do
    before do
      VCR.use_cassette('Train departing station') do
        @departing_station = @train.departing_station
      end
    end

    it { expect(@departing_station).to eq 'DOMODOSSOLA' }
  end

  describe '#arrivingStation' do
    before do
      VCR.use_cassette('Train arriving station') do
        @arriving_station = @train.arriving_station
      end
    end

    it { expect(@arriving_station).to eq 'MILANO PORTA GARIBALDI' }
  end

  describe '#scheduledDepartingTime' do
    before do
      VCR.use_cassette('Train scheduled departing time') do
        @scheduled_departing_time = @train.scheduled_departing_time
      end
    end

    it { expect(@scheduled_departing_time).to eq '18:10' }
  end

  describe '#scheduledArrivingTime' do
    before do
      VCR.use_cassette('Train scheduled arriving time') do
        @scheduled_arriving_time = @train.scheduled_arriving_time
      end
    end

    it { expect(@scheduled_arriving_time).to eq '20:13' }
  end

  describe '#actualDepartingTime' do
    before do
      VCR.use_cassette('Train actual departing time') do
        @actual_departing_time = @train.actual_departing_time
      end
    end

    it { expect(@actual_departing_time).to eq '18:11' }
  end

  describe '#actualArrivingTime' do
    before do
      VCR.use_cassette('Train actual arriving time') do
        @actual_arriving_time = @train.actual_arriving_time
      end
    end

    it { expect(@actual_arriving_time).to eq '20:15' }
  end

  describe '#scheduledStopTime' do
    before do
      VCR.use_cassette('Train scheduled stop time') do
        @scheduled_stop_time = @train.scheduled_stop_time('SESTO CALENDE')
      end
    end

    it { expect(@scheduled_stop_time).to eq '19:12' }
  end

  describe '#actualStopTime' do
    before do
      VCR.use_cassette('Train actual stop time') do
        @actual_stop_time = @train.actual_stop_time('SESTO CALENDE')
      end
    end

    it { expect(@actual_stop_time).to eq '19:16' }
  end

  describe '#lastStop' do
    before do
      VCR.use_cassette('Train last stop') do
        @last_stop = @train.last_stop
      end
    end

    it { expect(@last_stop).to eq '[X] MILANO PORTA GARIBALDI = SCHEDULED: 20:13 EXPECTED: 20:15' }
  end
end
