#!/usr/bin/env ruby

require_relative 'lib/p50x'

begin
  device = P50X::Device.new('/dev/tty.usbserial-140')

  # device.send(P50X::Commands::XPwrOn.new)
  # sleep 0.5
  # device.send(P50X::Commands::XPwrOff.new)

  loop do
    command = P50X::Commands::XEvtLok.new
    device.send(command, log: false)

    puts command.response if command.response.any?

    sleep 0.1
  end
ensure
  device.close
end
