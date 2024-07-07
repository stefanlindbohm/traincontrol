# frozen_string_literal: true

require_relative '../../lib/p50x'
require_relative '../../lib/traincontrol'

class TraincontrolUniverse
  include Singleton

  attr_reader :locomotives

  def initialize
    @intellibox = Traincontrol::Adapters::P50XAdapter.new('/dev/tty.usbserial-140')
    @locomotives = []

    at_exit do
      @intellibox.close
    end
  end

  def load_locomotives(addresses)
    addresses.each do |address|
      @locomotives << @intellibox.find_locomotive_decoder(address)
    end
  end

  def update
    @intellibox.update
  end

  def close
    @intellibox.close
  end
end

TraincontrolUniverse.instance.load_locomotives([3])
