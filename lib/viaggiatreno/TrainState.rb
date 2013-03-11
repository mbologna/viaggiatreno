class TrainState
	# Train Statuses
	@@RUNNING = "TRAVELING"
	@@FINISHED = "ARRIVED"
	@@NOT_STARTED = "NOT DEPARTED"

	def self.RUNNING() @@RUNNING end
	def self.FINISHED() @@FINISHED end
	def self.NOT_STARTED() @@NOT_STARTED end
end
