require_relative 'stop_state'

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
    if @status == StopState::DONE
      retstr += '[X] '
    elsif @status == StopState::TODO
      retstr += '[ ] '
    end
    retstr += "#{train_station} = SCHEDULED: #{scheduled_stop_time} EXPECTED: #{actual_stop_time}"
    retstr
  end
end
