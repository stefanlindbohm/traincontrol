# frozen_string_literal: true

class CommandStation < ApplicationRecord
  ADAPTERS = {
    'p50x' => ::CommandStationConfigurations::P50XConfiguration,
    'dummy' => ::CommandStationConfigurations::DummyConfiguration
  }.freeze

  validates :adapter_options, exclusion: [nil]

  after_initialize :set_defaults

  def adapter_configuration
    @adapter_configuration ||= ADAPTERS[adapter]&.new(adapter_options || {})
  end

  private

  def set_defaults
    self.adapter_options ||= {}
  end
end
