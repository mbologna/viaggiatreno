require_relative 'stop_state'

class TrainStop
  attr_accessor :trainStation, :scheduled_stop_time, :actual_stop_time, :status

  def initialize(trainStation, scheduled_stop_time, actual_stop_time, status)
    @trainStation = trainStation
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
    retstr += "#{trainStation} = SCHEDULED: #{scheduled_stop_time} EXPECTED: #{actual_stop_time}"
    retstr
  end
end
