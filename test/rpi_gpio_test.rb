require 'teststrap'

context 'rpi_gpio - ' do
  context 'verbose method - ' do
    context 'pin 12' do
      asserts 'can be activated' do
        pin = GPIOPin.new(12, :out)
        pin.export!
        ret = pin.activate
        pin.unexport!
        ret
      end

      asserts 'remains activated' do
        pin = GPIOPin.new(12, :in)
        pin.export!
        ret = pin.read
        pin.unexport!
        ret
      end
  
      asserts 'can be deactivated' do
        pin = GPIOPin.new(12, :out)
        pin.export!
        ret = pin.deactivate
        pin.unexport!
        ret
      end

      asserts 'remains deactivated' do
        pin = GPIOPin.new(12, :in)
        pin.export!
        ret = pin.read
        pin.unexport!
        ret
      end.equals(false)
    end
  end # 'verbose method'

  context 'destructive methods -' do
    context 'pin 12' do
      asserts 'can be activated' do
        GPIOPin.new(12, :out).activate
      end

      asserts 'remains activated' do
        GPIOPin.new(12, :in).read
      end

      asserts 'can be deactivated' do
        GPIOPin.new(12, :out).deactivate
      end

      asserts 'remains deactivated' do
        GPIOPin.new(12, :in).read
      end.equals(false)
    end
  end # 'destructive methods'
=begin
  context 'blocks -' do
    asserts 'can be activated' do
      GPIOPins.new(:out => [12]).export! do |p|
        p.activate!
      end
    end

    asserts 'remains activated' do
      GPIOPin.new(:in => [12]).export! do |p|
         p.read
      end
    end

    asserts 'can be deactivated' do
      GPIOPin.new(:out => [12]).export! do |p|
        p.deactivate
      end
    end

    asserts 'remains deactivated' do
      GPIPin.new(:in => [12]).export! do |p|
        p.read
      end
    end
  end
=end
end
