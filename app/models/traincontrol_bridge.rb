# frozen_string_literal: true

class TraincontrolBridge
  include Singleton

  attr_reader :runtime

  def initialize
    restart
  end

  def restart
    runtime&.stop
    @runtime = TracksideCommand::Runtime.new

    command_station = CommandStation.first
    return if command_station.nil?

    @current_command_station_id = command_station.id
    runtime.register_command_station(current_command_station_id, command_station.adapter_configuration.create_adapter)

    Locomotive.find_each do |locomotive|
      runtime.register_locomotive(locomotive.command_station_id, locomotive.address)
    end
    Turnout.find_each do |turnout|
      runtime.register_accessory_output(turnout.command_station_id, turnout.address)
    end
  rescue StandardError => e
    Rails.logger.error("Could not initialize command station due to error: #{e.message}")
    @current_command_station_id = nil
  end

  private

  attr_reader :current_command_station_id
end
