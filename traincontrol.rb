#!/usr/bin/env ruby

require_relative 'lib/p50x'
require_relative 'lib/traincontrol'

begin
  intellibox = Traincontrol::Adapters::P50XAdapter.new('/dev/tty.usbserial-140')
  sj_rc2 = intellibox.find_locomotive_decoder(3)
  puts sj_rc2.inspect

  sj_rc2.lights = true
  intellibox.update

  # ---
  intellibox.update
  intellibox.update
  puts sj_rc2.inspect
ensure
  intellibox&.close
end

# begin
#   device = P50X::Device.new('/dev/tty.usbserial-140')
#
#   # device.send(P50X::Commands::XPwrOn.new)
#   # sleep 0.5
#   # device.send(P50X::Commands::XPwrOff.new)
#
#   status_command = P50X::Commands::XLokCfg.new(3)
#   device.send(status_command)
#   puts status_command.response
#
#   # device.send(P50X::Commands::XLok.new(3, 0, :reverse, lights: true, functions: { f2: true }))
#
#   # loop do
#   #   command = P50X::Commands::XEvtLok.new
#   #   device.send(command, log: false)
#
#   #   puts command.response if command.response.any?
#
#   #   sleep 0.1
#   # end
# ensure
#   device&.close
# end
