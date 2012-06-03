# rpi_gpio-gem

A rubygem for interacting with the Raspberry Pi's GPIO pins.

This is verrrrrrrrrrrrrrrry loosely based on a
[Python library](https://code.google.com/p/raspberry-gpio-python/) with the
same goal, by Ben Croston.

## Note

**Programs which use this library can now be run as any user that has sudo privileges.**

This is because the code uses sudo and the permissions on `/sys/class/gpio`:

```bash
[root@fedora-arm ~]# ls -la /sys/class/ | grep gpio
drwxr-xr-x  2 root root 0 May 29 06:42 gpio
```

# Examples

### Set the pinout mode

The pinout mode can be either the Pi's pin numbers or the Broadcom GPIO
numbers.

```ruby
require 'rpi_gpio'
GPIOPin.pinout_mode = :rpi # use the Pi's pin numbers (default)
the_pin = GPIOPin.new(11, :in) # Pi pin 11 (Broadcom pin 17).

GPIOPin.pinout_mode = :bcm # Use Broadcom's GPIO numbers
the_pin = GPIOPin.new(11, :in) # Broadcom pin 11 (Pi pin 23).
```

### Read from an input pin.

```ruby
require 'rpi_gpio'
the_pin = GPIOPin.new(11, :in)
the_pin.read
```

## Output

### Write to an output pin.

```ruby
require 'rpi_gpio'
the_pin = GPIOPin.new(12, :out)
the_pin.read # Check the current state.
the_pin.activate # Write '1' to the pin.
the_pin.read # Check the current state.
the_pin.deactivate # Write '0' to the pin.
the_pin.read # Check the current state.
```

## Other Public Functions

### Export/unexport a pin at will.

```ruby
require 'rpi_gpio'
the_pin = GPIOPin.new(12, :out) # Defaults to being exported.
the_pin.unexport!
the_pin.export!
```

### Check whether or not the pin *is* exported.
```ruby
require 'rpi_gpio'
the_pin = GPIOPin.new(12, :out) # Defaults to being exported.
the_pin.exported? #=> true
the_pin.unexport!
the_pin.exported? #=> false
```

# License (MIT)

```
Copyright (c) 2012-present Ricky Elrod

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
