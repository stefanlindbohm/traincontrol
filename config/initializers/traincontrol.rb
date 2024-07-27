# frozen_string_literal: true

class TraincontrolUniverse
  include Singleton

  attr_reader :locomotives

  def initialize
    @intellibox = Traincontrol::Adapters::P50XAdapter.new('/dev/ttyUSB0')
    @locomotives = []

    at_exit do
      @intellibox.close
    end
  end

  def load_locomotives(addresses)
    @locomotives = addresses.map { @intellibox.find_locomotive_decoder(_1) }
  end

  def update
    @intellibox.update
  end
end

Rails.application.config.after_initialize do
  TraincontrolUniverse.instance.load_locomotives([3])
end
