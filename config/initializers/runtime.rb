# frozen_string_literal: true

Rails.application.config.after_initialize do
  next unless defined?(Rails::Server)

  # Trigger creation of bridge and thus start of runtime
  RuntimeBridge.shared = RuntimeBridge.new
end

Rails.application.reloader.before_class_unload do
  RuntimeBridge.shared&.stop
  RuntimeBridge.shared = nil
end
