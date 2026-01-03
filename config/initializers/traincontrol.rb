# frozen_string_literal: true

Rails.application.config.after_initialize do
  next unless defined?(Rails::Server)

  # Trigger creation of bridge and thus start of runtime
  TraincontrolBridge.instance
end
