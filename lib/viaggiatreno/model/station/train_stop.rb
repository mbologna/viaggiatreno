require_relative 'train_stop_state'

# Represent a stop in the journey of the train
class TrainStop
  attr_accessor :train_station, :scheduled_stop_time, :actual_stop_time,
                :scheduled_rail, :actual_rail, :status

  def initialize(train_station, stop_time, rail, status)
    @train_station = train_station
    @scheduled_stop_time, @actual_stop_time = stop_time
    @scheduled_rail, @actual_rail = rail
    @status = status
  end

  def to_s
    if @status == TrainStopState::DONE
      done = 'X'
      actual_or_expected = 'ACTUAL'
    elsif @status == TrainStopState::TO_BE_DONE
      done = ' '
      actual_or_expected = 'EXPECTED'
    end
    retstr = "[#{done}] #{train_station} = SCHEDULED: #{scheduled_stop_time}\
 #{actual_or_expected}: #{actual_stop_time}"
    retstr
  end
end
