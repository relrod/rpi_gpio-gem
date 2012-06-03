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
      end
    end
  end # 'verbose method'

  context 'destructive methods -' do
    context 'pin 12' do
      asserts 'can be activated' do
        GPIOPin.new(12, :out).activate!
      end

      asserts 'remains activated' do
        GPIOPin.new(12, :in).read
      end

      asserts 'can be deactivated' do
        GPIOPin.new(12, :out).deactivate!
      end

      asserts 'remains deactivated' do
        GPIPin.new(12, :in).read
      end
    end
  end # 'destructive methods'

  context 'blocks -' do
      asserts 'can be activated' do
        GPIOPin.new(12, :out).export! do |p|
          p.activate!
        end
      end

      asserts 'remains activated' do
        GPIOPin.new(12, :in).export! do |p|
          p.read
        end
      end

      asserts 'can be deactivated' do
        GPIOPin.new(12, :out).export! do |p|
          p.deactivate
        end
      end

      asserts 'remains deactivated' do
        GPIPin.new(12, :in).export! do |p|
          p.read
        end
      end
  end

end
