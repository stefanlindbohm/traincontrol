# frozen_string_literal: true

module P50X
  module Commands
    class XLok < Base
      CODE_POINT = 0x80.chr

      attr_reader :address, :force, :emergency_stop, :speed, :direction, :lights, :functions

      def initialize(address, speed, direction, emergency_stop:, lights:, functions: nil, force: false)
        super()

        @address = address
        @force = force
        @emergency_stop = emergency_stop
        @speed = speed
        @direction = direction
        @lights = lights
        @functions = functions
      end

      def to_bytestring
        CODE_POINT + pack_parameters
      end

      private

      def pack_parameters
        options_byte = 0x0
        options_byte |= 0x80 unless functions.nil?
        options_byte |= 0x40 if force
        options_byte |= 0x20 if direction == :forward
        options_byte |= 0x10 if lights
        options_byte |= 0x08 if functions&.[](:f4)
        options_byte |= 0x04 if functions&.[](:f3)
        options_byte |= 0x02 if functions&.[](:f2)
        options_byte |= 0x01 if functions&.[](:f1)

        speed_byte =
          if emergency_stop
            1
          elsif speed.zero?
            0
          else
            speed + 1
          end

        [@address, speed_byte, options_byte].pack('SCC')
      end
    end
  end
end
