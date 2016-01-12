require_relative 'Scraper.rb'
require_relative 'TrainState.rb'
require_relative 'TrainStop.rb'

class Train
  attr_accessor :trainNumber, :trainName, :delay, :status, :lastUpdate, :state

  def initialize(trainNumber)
    @trainNumber = trainNumber
    @scraper = Scraper.new(trainNumber.to_s, self)
    update
  end

  def update
    @scraper.updateTrain
  end

  def updateDetails
    @trainStops = []
    @scraper.updateTrainDetails
  end

  def to_s
    "#{@trainNumber} #{@trainName}: #{@status} state: #{@state}, \
    delay: #{@delay}, lastUpdate: #{@lastUpdate} #{@trainStops}"
  end

  def addStop(trainStop)
    @trainStops << trainStop
  end

  def trainStops
    if @trainStops.nil?
      updateDetails
    end
    @trainStops
  end

  def departingStation
    trainStops.first.trainStation.to_s
  end

  def arrivingStation
    trainStops.last.trainStation.to_s
  end

  def scheduledDepartingTime
    trainStops.first.scheduledStopTime.to_s
  end

  def scheduledArrivingTime
    trainStops.last.scheduledStopTime.to_s
  end

  def actualDepartingTime
    trainStops.first.actualStopTime.to_s
  end

  def actualArrivingTime
    trainStops.last.actualStopTime.to_s
  end

  def scheduledStopTime(stationName)
    trainStops.each do |trainStop|
      if trainStop.trainStation.to_s == stationName
        return trainStop.scheduledStopTime.to_s
      end
    end
  end

  def actualStopTime(stationName)
    trainStops.each do |trainStop|
      if trainStop.trainStation.to_s == stationName
        return trainStop.actualStopTime.to_s
      end
    end
  end

  def lastStop
    if trainStops[0].status.to_s != StopState::DONE
      return @trainStops[0].to_s
    end
    (trainStops.length - 1).times do |i|
      if trainStops[i].status.to_s == StopState::DONE && \
          trainStops[i + 1].status.to_s != StopState::DONE
        return trainStops[i].to_s
      end
    end
    trainStops[trainStops.length - 1].to_s
  end
end
