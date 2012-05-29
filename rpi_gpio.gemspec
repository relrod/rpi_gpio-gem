Gem::Specification.new do |s|
  s.name        = 'rpi_gpio'
  s.version     = '1.0.3'
  s.date        = '2012-05-29'
  s.homepage    = 'https://www.github.com/CodeBlock/rpi_gpio-gem'
  s.summary     = "A rubygem for communicating with the Raspberry Pi's GPIO pins."
  s.description = "This gem communicates with the Pi's /sys/class/gpio/* system. Scripts which use it must be run as root."
  s.authors     = ["Ricky Elrod"]
  s.email       = 'ricky@elrod.me'
  s.files       = ["lib/rpi_gpio.rb"]
end
