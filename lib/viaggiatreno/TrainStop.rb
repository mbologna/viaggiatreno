require_relative 'StopState'

class TrainStop
	attr_accessor :trainStation, :scheduledStopTime, :actualStopTime, :status

	def initialize(trainStation, scheduledStopTime, actualStopTime, status,railinfo)
		@trainStation = trainStation
		@scheduledStopTime = scheduledStopTime
		@actualStopTime = actualStopTime
		@status = status
		@rail_p=railinfo[1]
		@rail_r=railinfo[2]
	end

	def to_s
	    retstr = ""
		if @status == StopState.DONE
			retstr += "[X] " 
		elsif @status == StopState.TODO
			retstr += "[ ] " 
		end
		retstr += "#{trainStation} = SCHEDULED: #{scheduledStopTime} EXPECTED: #{actualStopTime} RAIL: #{@rail_p}, #{@rail_r} "
		return retstr
	end
end

