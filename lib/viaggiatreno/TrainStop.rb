require_relative 'StopState'

class TrainStop
  attr_accessor :trainStation, :scheduledStopTime, :actualStopTime, :status

  def initialize(trainStation, scheduledStopTime, actualStopTime, status)
    @trainStation = trainStation
    @scheduledStopTime = scheduledStopTime
    @actualStopTime = actualStopTime
    @status = status
  end

  def to_s
    retstr = ''
    if @status == StopState.DONE
      retstr += '[X] '
    elsif @status == StopState.TODO
      retstr += '[ ] '
    end
    retstr += "#{trainStation} = SCHEDULED: #{scheduledStopTime} EXPECTED: #{actualStopTime}"
    retstr
  end
end
