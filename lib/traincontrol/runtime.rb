# frozen_string_literal: true

module Traincontrol
  # Runtime is the main orchestrator of everything happening with command
  # stations, locomotives, accessories and simulations. Its main feature is the
  # `#tick` method that runs the world at a fixed interval.
  class Runtime
    RUN_LOOP_INTERVAL = 0.1

    def initialize
      @adapters = {}
      @command_stations = {}
      @locomotives = {}

      at_exit { stop }
      @run_loop = RunLoop.new(RUN_LOOP_INTERVAL) { tick }
    end

    def stop
      @run_loop.stop
      @command_stations.each_value(&:close)
      @command_stations = {}
      @locomotives = {}
    end

    def register_command_station(id, command_station)
      command_station.check_events
      @command_stations[id] = command_station
    end

    def register_locomotive(command_station_id, address)
      @locomotives[address] =
        find_command_station(command_station_id).find_locomotive_decoder(address)
    end

    def find_locomotive(address)
      @locomotives[address]
    end

    def update
      @command_stations.each_value(&:update)
    end

    private

    def tick
      @command_stations.each_value(&:check_events)
    end

    def find_command_station(id)
      @command_stations[id]
    end
  end
end
