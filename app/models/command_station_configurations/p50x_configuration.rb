# frozen_string_literal: true

module CommandStationConfigurations
  class P50XConfiguration
    attr_reader :serial_port

    def self.name
      'P50X'
    end

    def initialize(options)
      @serial_port = options['serial_port']
    end

    def create_adapter
      Traincontrol::Adapters::P50XAdapter.new(serial_port) if serial_port.present?
    end

    def available_serial_ports
      case Gem::Platform.local.os
      when 'darwin'
        `ls -1 /dev/tty.*`.split.index_with { _1.split('.').last }
      when 'linux'
        `ls -1 /dev/serial/by-id/*`.split.index_with { _1.split('/').last.gsub('_', ' ') }
      else
        {}
      end
    end
  end
end
