# frozen_string_literal: true

require 'throttler'

module Traincontrol
  module Decoders
    class DCCLocomotiveDecoder
      # TODO: This is here temporarily -- the Traincontrol module should not be dependent on Rails stuff
      include Turbo::Broadcastable

      DEFAULTS = {
        speed: 0,
        direction: :forward,
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

      attr_reader :address, :speed_steps, :speed, :direction, :lights, :f1, :f2, :f3, :f4, :f5, :f6, :f7, :f8

      def initialize(address, speed_steps: 128)
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
        # TODO: This is here temporarily -- the Traincontrol module should not be dependent on app or Rails stuff
        @broadcast_throttler.throttle do
          broadcast_refresh
        end
      end

      def update_attributes(attributes)
        attributes.each do |attribute, value|
          next if %i[address speed direction lights f1 f2 f3 f4 f5 f6 f7 f8].exclude?(attribute)

          send("#{attribute}=", value)
        end
      end

      def set_attributes(attributes)
        attributes.each do |attribute, value|
          next if %i[address speed direction lights f1 f2 f3 f4 f5 f6 f7 f8].exclude?(attribute)

          instance_variable_set("@#{attribute}", value)
        end
      end

      %i[address speed direction lights f1 f2 f3 f4 f5 f6 f7 f8].each do |attribute|
        define_method "#{attribute}=" do |new_value|
          return if instance_variable_get("@#{attribute}") == new_value

          instance_variable_set("@#{attribute}", new_value)
          @changed_attributes << attribute
        end
      end
    end
  end
end
