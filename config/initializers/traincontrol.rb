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

  def feedback_network
    @intellibox.s88_feedback_network
  end

  def load_locomotives(addresses)
    @locomotives = addresses.map { @intellibox.find_locomotive_decoder(_1) }
  end

  def update
    @intellibox.update
  end
end

Rails.application.config.after_initialize do
  next unless defined?(::Rails::Server)

  TraincontrolUniverse.instance.load_locomotives([3])
  # @sensor_timer = SensorTimer.new(0.541,
  #                                 TraincontrolUniverse.instance.feedback_network.contacts[0],
  #                                 TraincontrolUniverse.instance.feedback_network.contacts[1],
  #                                 TraincontrolUniverse.instance.locomotives[0])
end
