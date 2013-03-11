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
		if @status == StopState.DONE
			return "[X] #{trainStation} = SCHEDULED: #{scheduledStopTime} ACTUAL: #{actualStopTime}\n"
		elsif @status == StopState.TODO
			return "[ ] #{trainStation} = SCHEDULED: #{scheduledStopTime} EXPECTED: #{actualStopTime}\n"
		end
	end
end
