require 'viaggiatreno'

station = Station.new('Milano Lancetti')

puts "#{station.station_name} station status:"
puts "\t" + 'Outgoing: '
station.outgoing_trains.each do |train|
  stop = train.find_stop(station.station_name)
  destination = train.stops.last
  puts "\t\t" + "Platform #{stop.scheduled_platform}:\
 #{train.train_number} [#{stop.scheduled_stop_time}] ->\
 #{destination.train_station} [#{destination.scheduled_stop_time}]"
end

puts "\t" + 'Incoming: '
station.incoming_trains.each do |train|
  stop = train.find_stop(station.station_name)
  origin = train.stops.first
  puts "\t\t" + "Platform #{stop.scheduled_platform}:\
 #{train.train_number} [#{stop.scheduled_stop_time}]\
 <- #{origin.train_station} [#{origin.scheduled_stop_time}]"
end
