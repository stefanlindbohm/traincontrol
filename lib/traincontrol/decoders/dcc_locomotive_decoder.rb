# frozen_string_literal: true

require 'throttler'

module Traincontrol
  module Decoders
    class DCCLocomotiveDecoder
      # TODO: This is here temporarily -- the Traincontrol module should not be dependent on Rails stuff
      include Turbo::Broadcastable

      ATTRIBUTES = %i[speed direction emergency_stop lights f1 f2 f3 f4 f5 f6 f7 f8].freeze
      DEFAULTS = {
        speed: 0,
        direction: :forward,
        emergency_stop: false,
        lights: false,
        f1: false,
        f2: false,
        f3: false,
        f4: false,
        f5: false,
        f6: false,
        f7: false,
        f8: false
      }.freeze

      attr_reader :address, :speed_steps, *ATTRIBUTES

      def initialize(address, speed_steps: 127)
        @address = address
        @speed_steps = speed_steps
        @changed_attributes = Set.new
        @broadcast_throttler = Throttler.new
        set_attributes(DEFAULTS)
      end

      def changed?
        @changed_attributes.any?
      end

      def clear_changes
        @changed_attributes.clear
        broadcast_refresh_throttled
      end

      def update_attributes(attributes)
        attributes.each do |attribute, value|
          next if ATTRIBUTES.exclude?(attribute)

          send("#{attribute}=", value)
        end
      end

      def set_attributes(attributes)
        attributes.each do |attribute, value|
          next if ATTRIBUTES.exclude?(attribute)

          instance_variable_set("@#{attribute}", value)
        end

        broadcast_refresh_throttled
      end

      ATTRIBUTES.each do |attribute|
        define_method "#{attribute}=" do |new_value|
          return if instance_variable_get("@#{attribute}") == new_value

          instance_variable_set("@#{attribute}", new_value)
          @changed_attributes << attribute
        end
      end

      private

      # TODO: This is here temporarily -- the Traincontrol module should not be
      # dependent on app or Rails stuff
      def broadcast_refresh_throttled
        @broadcast_throttler.throttle do
          broadcast_refresh
        end
      end
    end
  end
end
