# frozen_string_literal: true

module CommandStationConfigurations
  class DummyConfiguration
    def self.name
      'Dummy'
    end

    def initialize(_options); end

    def create_adapter
      Traincontrol::Adapters::DummyAdapter.new
    end
  end
end
