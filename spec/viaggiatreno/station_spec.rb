require 'simplecov'
SimpleCov.start
require 'spec_helper'
require 'viaggia_treno'

describe Station do
  describe 'Station with arriving and departing trains' do
    before do
      VCR.use_cassette('Station with arriving and departing trains') do
        @station = Station.new("Bergamo")
      end
    end

    it do
      expect(@station.station_name).to eq 'BERGAMO'
      expect(@station.outgoing_trains.size).to eq 2
      expect(@station.incoming_trains.size).to eq 6

      expect(@station.outgoing_trains.map(&:departing_station).uniq).to eq ['BERGAMO']

      expect(@station.outgoing_trains[0].arriving_station).to eq 'MILANO CENTRALE'
      expect(@station.outgoing_trains[0].scheduled_departing_time).to eq '22:02'
      expect(@station.outgoing_trains[0].scheduled_arriving_time).to eq '22:50'
      expect(@station.outgoing_trains[0].scheduled_departing_platform).to eq '5'
      expect(@station.outgoing_trains[0].scheduled_arriving_platform).to eq '12'
      expect(@station.outgoing_trains[0].actual_departing_time).to eq nil
      expect(@station.outgoing_trains[0].actual_arriving_time).to eq nil
      expect(@station.outgoing_trains[0].actual_departing_platform).to eq nil
      expect(@station.outgoing_trains[0].actual_arriving_platform).to eq nil
      expect(@station.outgoing_trains[0].delay).to eq nil
      expect(@station.outgoing_trains[0].state).to eq 'NOT DEPARTED'
      expect(@station.outgoing_trains[0].last_stop).to eq nil
      expect(@station.outgoing_trains[0].actual_stop_time('BERGAMO')).to eq nil

      expect(@station.outgoing_trains[1].arriving_station).to eq 'MILANO CENTRALE'
      expect(@station.outgoing_trains[1].scheduled_departing_time).to eq '23:00'
      expect(@station.outgoing_trains[1].scheduled_arriving_time).to eq '23:50'
      expect(@station.outgoing_trains[1].scheduled_departing_platform).to eq '2'
      expect(@station.outgoing_trains[1].scheduled_arriving_platform).to eq '7'
      expect(@station.outgoing_trains[1].actual_departing_time).to eq nil
      expect(@station.outgoing_trains[1].actual_arriving_time).to eq nil
      expect(@station.outgoing_trains[1].actual_departing_platform).to eq nil
      expect(@station.outgoing_trains[1].actual_arriving_platform).to eq nil
      expect(@station.outgoing_trains[1].delay).to eq nil
      expect(@station.outgoing_trains[1].state).to eq 'NOT DEPARTED'
      expect(@station.outgoing_trains[1].last_stop).to eq nil
      expect(@station.outgoing_trains[1].actual_stop_time('MILANO CENTRALE')).to eq nil
      
      expect(@station.incoming_trains.map(&:arriving_station).uniq).to eq ['BERGAMO']

      expect(@station.incoming_trains[0].departing_station).to eq 'MILANO CENTRALE'
      expect(@station.incoming_trains[0].scheduled_departing_time).to eq '21:05'
      expect(@station.incoming_trains[0].scheduled_arriving_time).to eq '21:53'
      expect(@station.incoming_trains[0].scheduled_departing_platform).to eq '12'
      expect(@station.incoming_trains[0].scheduled_arriving_platform).to eq '2'
      expect(@station.incoming_trains[0].actual_departing_time).to eq '21:07'
      expect(@station.incoming_trains[0].actual_arriving_time).to eq '21:54'
      expect(@station.incoming_trains[0].actual_departing_platform).to eq nil
      expect(@station.incoming_trains[0].actual_arriving_platform).to eq '2'
      expect(@station.incoming_trains[0].delay).to eq 2
      expect(@station.incoming_trains[0].state).to eq 'ARRIVED'
      expect(@station.incoming_trains[0].last_stop.train_station).to eq 'BERGAMO'
      expect(@station.incoming_trains[0].actual_stop_time('BERGAMO')).to eq '21:54'
      
      expect(@station.incoming_trains[1].departing_station).to eq 'BRESCIA'
      expect(@station.incoming_trains[1].scheduled_departing_time).to eq '21:00'
      expect(@station.incoming_trains[1].scheduled_arriving_time).to eq '22:02'
      expect(@station.incoming_trains[1].scheduled_departing_platform).to eq '3'
      expect(@station.incoming_trains[1].scheduled_arriving_platform).to eq '4'
      expect(@station.incoming_trains[1].actual_departing_time).to eq '21:00'
      expect(@station.incoming_trains[1].actual_arriving_time).to eq '22:11'
      expect(@station.incoming_trains[1].actual_departing_platform).to eq '3'
      expect(@station.incoming_trains[1].actual_arriving_platform).to eq nil
      expect(@station.incoming_trains[1].delay).to eq 9
      expect(@station.incoming_trains[1].state).to eq 'TRAVELING'
      expect(@station.incoming_trains[1].last_stop.train_station).to eq 'MONTELLO GORLAGO'
      expect(@station.incoming_trains[1].actual_stop_time('BERGAMO')).to eq '22:11'
      
      expect(@station.incoming_trains[2].departing_station).to eq 'TREVIGLIO'
      expect(@station.incoming_trains[2].scheduled_departing_time).to eq '22:08'
      expect(@station.incoming_trains[2].scheduled_arriving_time).to eq '22:38'
      expect(@station.incoming_trains[2].scheduled_departing_platform).to eq '2 Ovest'
      expect(@station.incoming_trains[2].scheduled_arriving_platform).to eq '1'
      expect(@station.incoming_trains[2].actual_departing_time).to eq nil
      expect(@station.incoming_trains[2].actual_arriving_time).to eq nil
      expect(@station.incoming_trains[2].actual_departing_platform).to eq nil
      expect(@station.incoming_trains[2].actual_arriving_platform).to eq nil
      expect(@station.incoming_trains[2].delay).to eq nil
      expect(@station.incoming_trains[2].state).to eq 'NOT DEPARTED'
      expect(@station.incoming_trains[2].last_stop).to eq nil
      expect(@station.incoming_trains[2].actual_stop_time('BERGAMO')).to eq nil

      expect(@station.incoming_trains[3].departing_station).to eq 'MILANO CENTRALE'
      expect(@station.incoming_trains[3].scheduled_departing_time).to eq '22:05'
      expect(@station.incoming_trains[3].scheduled_arriving_time).to eq '22:55'
      expect(@station.incoming_trains[3].scheduled_departing_platform).to eq '10'
      expect(@station.incoming_trains[3].scheduled_arriving_platform).to eq '7'
      expect(@station.incoming_trains[3].actual_departing_time).to eq nil
      expect(@station.incoming_trains[3].actual_arriving_time).to eq nil
      expect(@station.incoming_trains[3].actual_departing_platform).to eq nil
      expect(@station.incoming_trains[3].actual_arriving_platform).to eq nil
      expect(@station.incoming_trains[3].delay).to eq nil
      expect(@station.incoming_trains[3].state).to eq 'NOT DEPARTED'
      expect(@station.incoming_trains[3].last_stop).to eq nil
      expect(@station.incoming_trains[3].actual_stop_time('BERGAMO')).to eq nil

      expect(@station.incoming_trains[4].departing_station).to eq 'PISA CENTRALE'
      expect(@station.incoming_trains[4].scheduled_departing_time).to eq '18:22'
      expect(@station.incoming_trains[4].scheduled_arriving_time).to eq '23:04'
      expect(@station.incoming_trains[4].scheduled_departing_platform).to eq '7'
      expect(@station.incoming_trains[4].scheduled_arriving_platform).to eq '4'
      expect(@station.incoming_trains[4].actual_departing_time).to eq "18:22"
      expect(@station.incoming_trains[4].actual_arriving_time).to eq "23:07"
      expect(@station.incoming_trains[4].actual_departing_platform).to eq nil
      expect(@station.incoming_trains[4].actual_arriving_platform).to eq nil
      expect(@station.incoming_trains[4].delay).to eq 3
      expect(@station.incoming_trains[4].state).to eq 'TRAVELING'
      expect(@station.incoming_trains[4].last_stop.train_station).to eq 'VEROLANUOVA'
      expect(@station.incoming_trains[4].actual_stop_time('PALAZZOLO SULL`OGLIO')).to eq '22:43'

      expect(@station.incoming_trains[5].departing_station).to eq 'ROMA TERMINI'
      expect(@station.incoming_trains[5].scheduled_departing_time).to eq '18:45'
      expect(@station.incoming_trains[5].scheduled_arriving_time).to eq '23:10'
      expect(@station.incoming_trains[5].scheduled_departing_platform).to eq '4'
      expect(@station.incoming_trains[5].scheduled_arriving_platform).to eq '3'
      expect(@station.incoming_trains[5].actual_departing_time).to eq "18:48"
      expect(@station.incoming_trains[5].actual_arriving_time).to eq "23:10"
      expect(@station.incoming_trains[5].actual_departing_platform).to eq '7'
      expect(@station.incoming_trains[5].actual_arriving_platform).to eq nil
      expect(@station.incoming_trains[5].delay).to eq 0
      expect(@station.incoming_trains[5].state).to eq 'TRAVELING'
      expect(@station.incoming_trains[5].last_stop.train_station).to eq 'VERONA PORTA NUOVA'
      expect(@station.incoming_trains[5].actual_stop_time('BOLOGNA C.LE/AV')).to eq '20:48'
    end
  end

  describe 'Not existing station' do
    before do
      VCR.use_cassette('Not existing station') do
        @station = Station.new("Not exists")
      end
    end

    it do
      expect(@station.station_name).to eq nil
    end
  end
end
