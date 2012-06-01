#!/usr/bin/env ruby
# Ricky Elrod <ricky@elrod.me>
# License: MIT
# Provide Raspberry Pi GPIO control via Ruby.
# NOTE: *Internally* we *always* deal with BCM.
# This means that @pin is *always* the BCM version.

class GPIOPin
  @pinout_mode = :rpi # :rpm or :bcm

  class << self
    attr_accessor :pinout_mode
  end
  
  def self.pins_in_use
    pins = `sudo ls /sys/class/gpio`.scan(/(?:gpio)(\d+)/).flatten.map!(&:to_i)
    pins.map!{|pin| PINS.invert[pin]} if @pinout_mode == :rpi
    pins
  end

  # This is a hash of rpi -> bcm GPIO pin numbers.
  PINS = {
    # rpi => bcm
    3 => 0,
    5 => 1,
    7 => 4,
    8 => 14,
    10 => 15,
    11 => 17,
    12 => 18,
    13 => 21,
    15 => 22,
    16 => 23,
    17 => 24,
    19 => 10,
    21 => 9,
    22 => 25,
    23 => 11,
    24 => 8,
    26 => 7,
  }

  class InvalidPinError < StandardError; end
  class InvalidDirectionError < StandardError; end
  class WrongDirectionError < StandardError; end

  # Public: Initialize an instance of GPIOPin.
  #
  # Export the pin and set its direction, as well.
  #
  # pin - The pin number (Integer) to control.
  #
  # Returns the instance of GPIOPin.
  def initialize(pin, direction)
    unless ['in', 'out'].include? (@direction = direction.to_s)
      raise InvalidDirectionError, "Direction should be :in or :out."
    end

    if GPIOPin.pinout_mode == :bcm && PINS.values.include?(pin)
      @pin = pin
    elsif GPIOPin.pinout_mode == :rpi && PINS.keys.include?(pin)
      @pin = PINS[pin]
    else
      raise InvalidPinError, "That pin doesn't exist for this pinout mode."
    end

    unexport! if is_exported?
    export!
  end

  # Public: Exports the pin.
  def export!
    `sudo bash -c "echo #{@pin} > /sys/class/gpio/export"`
    `sudo bash -c "echo #{@direction} > /sys/class/gpio/gpio#{@pin}/direction"`
    is_exported?
  end

  # Public: Unexports the pin.
  #
  # Returns nothing.
  def unexport!
    `sudo bash -c "echo #{@pin} > /sys/class/gpio/unexport"`
    !is_exported?
  end

  # Public: Activate the pin
  #
  # Returns nothing.
  def activate
    raise WrongDirectionError, "This pin is an input." if @direction == 'in'
    write 1, "/sys/class/gpio/gpio#{@pin}/value"
    read
  end

  # Public: Deactivate the pin
  #
  # Returns nothing.
  def deactivate
    raise WrongDirectionError, "This pin is an input." if @direction == 'in'
    write 0, "/sys/class/gpio/gpio#{@pin}/value"
    read
  end

  # Public: Read from the pin
  #
  # Returns true if the pin is pulled, false if not.
  def read
    status = `sudo cat /sys/class/gpio/gpio#{@pin}/value`.chomp
    status == '1'
  end

  # Public: Determines if the pin is exported or not.
  #
  # Returns true if it is exported, false if not.
  def is_exported?
    `sudo [ -d /sys/class/gpio/gpio#{@pin} ] && echo true || false`.chomp == 'true'
  end
    
  def write(value, destination)
    `sudo bash -c "echo #{value} > #{destination} && echo true || false"`.chomp == 'true'
  end

end
