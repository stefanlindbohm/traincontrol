# frozen_string_literal: true

module Traincontrol
  module Decoders
    class DCCLocomotiveDecoder
      attr_reader :address, :speed_steps, :speed, :direction, :lights, :f1, :f2, :f3, :f4, :f5, :f6, :f7, :f8

      def initialize(address, speed_steps: 128)
        @address = address
        @speed_steps = speed_steps
        @changed_attributes = Set.new

        # Defaults
        @speed = 0
        @direction = :forward
        @lights = false
        @f1 = false
        @f2 = false
        @f3 = false
        @f4 = false
        @f5 = false
        @f6 = false
        @f7 = false
        @f8 = false
      end

      def changed?
        @changed_attributes.any?
      end

      def clear_changes
        @changed_attributes.clear
      end

      def set_attributes(attributes)
        attributes.each do |attribute, value|
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
