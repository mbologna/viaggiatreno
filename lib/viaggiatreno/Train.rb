require_relative 'Scraper.rb'
require_relative 'TrainState.rb'
require_relative 'TrainStop.rb'

class Train
  attr_accessor :trainNumber, :trainName, :delay, :status, :lastUpdate, :state

  def initialize(trainNumber)
    @trainNumber = trainNumber
    @scraper = Scraper.new(trainNumber.to_s, self)
    self.update()
  end

  def update()
    @scraper.updateTrain()
  end

  def updateDetails()
    @trainStops = Array.new
    @scraper.updateTrainDetails()
  end

  def to_s
   return "#{@trainNumber} #{@trainName}: #{@status} state: #{@state}, \
   delay: #{@delay}, lastUpdate: #{@lastUpdate} #{@trainStops}"
  end

  def addStop(trainStop)
    @trainStops << trainStop
  end

  def trainStops()
    if @trainStops == nil
      self.updateDetails()
    end
    @trainStops
  end

  def departingStation()
    self.trainStops.first.trainStation.to_s
  end

  def arrivingStation()
    self.trainStops.last.trainStation.to_s
  end

  def scheduledDepartingTime()
    self.trainStops.first.scheduledStopTime.to_s
  end

  def scheduledArrivingTime()
    self.trainStops.last.scheduledStopTime.to_s
  end

  def actualDepartingTime()
    self.trainStops.first.actualStopTime.to_s
  end

  def actualArrivingTime()
    self.trainStops.last.actualStopTime.to_s
  end

  def scheduledStopTime(stationName) 
    self.trainStops.each do |trainStop| 
      if trainStop.trainStation.to_s == stationName 
        return trainStop.scheduledStopTime.to_s
      end
    end
  end

  def actualStopTime(stationName) 
    self.trainStops.each do |trainStop| 
      if trainStop.trainStation.to_s == stationName 
        return trainStop.actualStopTime.to_s
      end
    end
  end

  def lastStop() 
    if self.trainStops[0].status.to_s != StopState.DONE
      return @trainStops[0].to_s
    end
    (self.trainStops.length-1).times do |i|
      if self.trainStops[i].status.to_s == StopState.DONE && \
          self.trainStops[i+1].status.to_s != StopState.DONE
        return self.trainStops[i].to_s
      end
    end
    return self.trainStops[self.trainStops.length-1].to_s
  end
end  

