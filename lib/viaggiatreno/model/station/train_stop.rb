require_relative 'train_stop_state'

# Represent a stop in the journey of the train
class TrainStop
  attr_accessor :train_station, :scheduled_stop_time, :actual_stop_time,
                :scheduled_platform, :actual_platform, :state

  def initialize(train_station, stop_time, platform, state)
    @train_station = train_station
    @scheduled_stop_time, @actual_stop_time = stop_time
    @scheduled_platform, @actual_platform = platform
    @state = state
    @actual_stop_time, @actual_platform = nil if state == TrainStopState::SUPPRESSED
  end
end

class StopNotFound < StandardError
end
