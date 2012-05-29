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

    if @pinout_mode == :bcm && PINS.values.include?(pin)
      @pin = pin
    elsif @pinout_mode == :rpi && PINS.keys.include?(pin)
      @pin = PINS[pin]
    else
      raise InvalidPinError, "That pin doesn't exist for this pinout mode."
    end

    unexport! if is_exported?
    export!
  end

  # Public: Exports the pin.
  def export!
    File.open "/sys/class/gpio/unexport" do |f|
      f.write @pin
    end

    File.open "/sys/class/gpio/gpio#{@pin}/direction" do |f|
      f.write @direction
    end
  end

  # Public: Unexports the pin.
  #
  # Returns nothing.
  def unexport!
    File.open "/sys/class/gpio/unexport" do |f|
      f.write @pin
    end
  end

  # Public: Activate the pin
  #
  # Returns nothing.
  def activate
    raise WrongDirectionError, "This pin is an input." if @direction == 'in'
    File.open "/sys/class/gpio/gpio#{@pin}/value" do |f|
      f.write 1
    end
  end

  # Public: Deactivate the pin
  #
  # Returns nothing.
  def deactivate
    raise WrongDirectionError, "This pin is an input." if @direction == 'in'
    File.open "/sys/class/gpio/gpio#{@pin}/value" do |f|
      f.write 0
    end
  end

  # Public: Read from the pin
  #
  # Returns true if the pin is pulled, false if not.
  def read
    raise WrongDirectionError, "This pin is an output." if @direction == 'out'
    status = IO.read "/sys/class/gpio/gpio#{@pin}/value"
    status == '1'
  end

  # Public: Determines if the pin is exported or not.
  #
  # Returns true if it is exported, false if not.
  def is_exported?
    File.exists? "/sys/class/gpio/gpio#{@pin}"
  end
end
