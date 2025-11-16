# frozen_string_literal: true

Rails.application.config.after_initialize do
  next unless defined?(::Rails::Server)

  $traincontrol&.exit
  $traincontrol = Traincontrol::Runtime.new
  $traincontrol.register_command_station(
    :intellibox,
    Traincontrol::Adapters::P50XAdapter.new('/dev/ttyUSB0')
  )
  [3].each do |address|
    $traincontrol.register_locomotive(:intellibox, address)
  end
end
