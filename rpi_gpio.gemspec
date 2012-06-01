Gem::Specification.new do |s|
  s.name        = 'rpi_gpio'
  s.version     = '1.1.0'
  s.date        = '2012-06-01'
  s.homepage    = 'https://www.github.com/klappy/rpi_gpio-gem'
  s.summary     = "A rubygem for communicating with the Raspberry Pi's GPIO pins."
  s.description = "This gem communicates with the Pi's /sys/class/gpio/* system. Scripts which use it must be run as a user with sudo privliges."
  s.authors     = ["Ricky Elrod", "Christopher Klapp"]
  s.email       = 'ricky@elrod.me'
  s.files       = ["lib/rpi_gpio.rb"]
end
