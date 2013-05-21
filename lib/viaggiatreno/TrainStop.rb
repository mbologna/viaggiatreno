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
	    retstr = ""
		if @status == StopState.DONE
			retstr += "\n[X]" 
		elsif @status == StopState.TODO
			retstr += "\n[ ]" 
		end
		retstr += "#{trainStation} = SCHEDULED: #{scheduledStopTime} \
		    EXPECTED: #{actualStopTime}\n"
		return retstr
	end
end

