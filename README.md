# Viaggiatreno

<!-- [![Build Status](https://travis-ci.org/mbologna/viaggiatreno.svg)](https://travis-ci.org/mbologna/viaggiatreno)
[![Code Climate](https://codeclimate.com/repos/569a5314b23bff7a6c011fb0/badges/7a1d250d86b806acee6c/gpa.svg)](https://codeclimate.com/repos/569a5314b23bff7a6c011fb0/feed)
[![Test Coverage](https://codeclimate.com/repos/569a5314b23bff7a6c011fb0/badges/7a1d250d86b806acee6c/coverage.svg)](https://codeclimate.com/repos/569a5314b23bff7a6c011fb0/coverage)
[![Issue Count](https://codeclimate.com/repos/569a5314b23bff7a6c011fb0/badges/7a1d250d86b806acee6c/issue_count.svg)](https://codeclimate.com/repos/569a5314b23bff7a6c011fb0/feed) -->

This gem parses Italian railway real-time status for trains (viaggiatreno.it).
Use this API to fetch online information about Italian trains.

## Installation

Add this line to your application's Gemfile:

    gem 'viaggiatreno'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install viaggiatreno

## Usage

### Find the status of a train

Let's say you are interested in knowing the status of the train number 9657.

1. Create a new `Train` object by passing the train number as argument

    ```
    irb(main):001:0> require 'viaggiatreno'
    irb(main):005:0> train = Train.new(9657)
    => #<Train:0x000055ad61b53f88 @train_number=9657, @scraper=#<Scraper:0x000055ad61b53ee8 @site_info_main="http://mobile.viaggiatreno.it/vt_pax_internet/mobile/numero?numeroTreno=9657&tipoRicerca=numero&lang=IT", @site_info_details="http://mobile.viaggiatreno.it/vt_pax_internet/mobile/scheda?dettaglio=visualizza&numeroTreno=9657&tipoRicerca=numero&lang=IT", @train=#<Train:0x000055ad61b53f88 ...>>, @status="Il treno viaggia con 7 minuti di ritardo", @train_name="ES* 9657", @state="TRAVELING", @delay=7, @last_update="PdE 2AV alle ore 19:11">
    ```

    You can already see that some useful information has been inserted into the object

2. Query the status of the train

    ```
    irb(main):006:0> train.status
    => "Il treno viaggia con 7 minuti di ritardo"
    ```

3. Show the delay in minutes

    ```
    irb(main):007:0> train.delay
    => 7
    ```

4. Is the train TRAVELING, ARRIVED or NOT DEPARTED yet?

    ```
    irb(main):008:0> train.state
    => "TRAVELING"
    ```

5.  Get a summary of the status of the train

    ```
    irb(main):012:0> puts train
    9657 ES* 9657: Il treno viaggia con 7 minuti di ritardo state: TRAVELING,     delay: 7, last_update: PdE 2AV alle ore 19:11
    ```

6. Refresh the information about the train and show the last update location and time

    ```
    irb(main):007:0> train.last_update
    => "PDE QUINZANO alle ore 19:46"
    irb(main):006:0> train.update
    => nil
    irb(main):010:0> train.last_update
    => "PDE MONTE BIBELE alle ore 19:47"
    ```

7. Show the stops the train has already done and the one to done yet with scheduled and actual (or expected) time:

    ```
    irb(main):015:0> puts train.train_stops
    [X] MILANO CENTRALE = SCHEDULED: 18:00 ACTUAL: 18:03
    [X] MILANO ROGOREDO = SCHEDULED: 18:08 ACTUAL: 18:09
    [ ] ROMA TERMINI = SCHEDULED: 20:55 EXPECTED: 21:30
    [ ] NAPOLI CENTRALE = SCHEDULED: 22:15 EXPECTED: 22:50
    => nil
    ```

8. Know the last stop the train has done

    ```
    irb(main):022:0> train.last_stop
    => "[X] MILANO ROGOREDO = SCHEDULED: 18:08 ACTUAL: 18:09"
    ```

9. Look up when a stop in a particular station is expected (or has actually been happened)

    ```
    irb(main):026:0> train.scheduled_stop_time("MILANO ROGOREDO")
    => "18:08 [DONE]"
    irb(main):027:0> train.scheduled_stop_time("ROMA TERMINI")
    => "20:55 [TO_BE_DONE]"
    ```

10. Every information is gathered by calling the right method, e.g. rail related methods `scheduled_rail` and `actual_rail`:

    ```
    => [#<TrainStop:0x0000562325457420 @train_station="MILANO CENTRALE", @scheduled_stop_time="18:00", @actual_stop_time="18:03", @scheduled_rail="17", @actual_rail=nil, @status="DONE">, #<TrainStop:0x00005623254634f0 @train_station="MILANO ROGOREDO", @scheduled_stop_time="18:08", @actual_stop_time="18:09", @scheduled_rail="6", @actual_rail="6", @status="DONE">, #<TrainStop:0x00005623254610b0 @train_station="ROMA TERMINI", @scheduled_stop_time="20:55", @actual_stop_time="21:30", @scheduled_rail="5", @actual_rail=nil, @status="TO_BE_DONE">, #<TrainStop:0x000056232546a3e0 @train_station="NAPOLI CENTRALE", @scheduled_stop_time="22:15", @actual_stop_time="22:50", @scheduled_rail="18", @actual_rail=nil, @status="TO_BE_DONE">]
    ```

11. Notify any potential delays using simple math

    ```
    if train.delay.to_i >= 10 or train.state != "TRAVELING" or \
    (train.state == "TRAVELING" and Time.now - Time.parse(train.last_update) >= 10*60)
        puts "Notify user of delayed train!"
    end
    ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
