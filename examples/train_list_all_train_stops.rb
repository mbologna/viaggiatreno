require 'viaggiatreno'

train = Train.new(23168)
origin = train.stops.first
destination = train.stops.last
puts "#{train.train_number}: [#{origin.scheduled_stop_time}]\
 #{origin.train_station} -> [#{destination.scheduled_stop_time}]\
 #{destination.train_station}"
puts "#{train.status}"
puts ''
train.stops.each do |stop|
  done_or_todo = ''
  actual_or_expected = ''
  if stop.status == TrainStopState::DONE
    done_or_todo = 'X'
    actual_or_expected = 'actual'
  elsif stop.status == TrainStopState::TO_BE_DONE
    done_or_todo = ' '
    actual_or_expected = 'expected'
  end
  puts "[#{done_or_todo}] #{stop.train_station}\
 [#{stop.scheduled_stop_time} #{actual_or_expected}:\
 #{stop.actual_stop_time}] -\
 Platform: #{stop.actual_platform} (expected:\
 #{stop.scheduled_platform})"
end

train = Train.new(9565)
origin = train.stops.first
destination = train.stops.last
puts "#{train.train_number}: [#{origin.scheduled_stop_time}]\
 #{origin.train_station} -> [#{destination.scheduled_stop_time}]\
 #{destination.train_station}"
puts "#{train.status}"
puts ''
train.stops.each do |stop|
  done_or_todo = ''
  actual_or_expected = ''
  if stop.status == TrainStopState::DONE
    done_or_todo = 'X'
    actual_or_expected = 'actual'
  elsif stop.status == TrainStopState::TO_BE_DONE
    done_or_todo = ' '
    actual_or_expected = 'expected'
  end
  puts "[#{done_or_todo}] #{stop.train_station}\
 [#{stop.scheduled_stop_time} #{actual_or_expected}:\
 #{stop.actual_stop_time}] -\
 Platform: #{stop.actual_platform} (expected:\
 #{stop.scheduled_platform})"
end

train = Train.new(23331)
origin = train.stops.first
destination = train.stops.last
puts "#{train.train_number}: [#{origin.scheduled_stop_time}]\
 #{origin.train_station} -> [#{destination.scheduled_stop_time}]\
 #{destination.train_station}"
puts "#{train.status}"
puts ''
train.stops.each do |stop|
  done_or_todo = ''
  actual_or_expected = ''
  if stop.status == TrainStopState::DONE
    done_or_todo = 'X'
    actual_or_expected = 'actual'
  elsif stop.status == TrainStopState::TO_BE_DONE
    done_or_todo = ' '
    actual_or_expected = 'expected'
  end
  puts "[#{done_or_todo}] #{stop.train_station}\
 [#{stop.scheduled_stop_time} #{actual_or_expected}:\
 #{stop.actual_stop_time}] -\
 Platform: #{stop.actual_platform} (expected:\
 #{stop.scheduled_platform})"
end
