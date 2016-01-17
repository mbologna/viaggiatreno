require_relative 'train_stop_state'

class TrainStop
  attr_accessor :train_station, :scheduled_stop_time, :actual_stop_time, :status

  def initialize(train_station, scheduled_stop_time, actual_stop_time, status)
    @train_station = train_station
    @scheduled_stop_time = scheduled_stop_time
    @actual_stop_time = actual_stop_time
    @status = status
  end

  def to_s
    retstr = ''
    if @status == TrainStopState::DONE
      done = 'X'
      actual_or_expected = 'ACTUAL'
    elsif @status == TrainStopState::TODO
      done = ' '
      actual_or_expected = 'EXPECTED'
    end
    retstr += "[#{done}] #{train_station} = SCHEDULED: #{scheduled_stop_time}"\
              " #{actual_or_expected}: #{actual_stop_time}"
    retstr
  end
end
