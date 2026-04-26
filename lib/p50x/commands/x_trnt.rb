# frozen_string_literal: true

module P50X
  module Commands
    class XTrnt < Base
      CODE_POINT = 0x90.chr

      attr_reader :address, :closed, :status, :reserved, :no_command

      def initialize(address, closed, status, reserved: false, no_command: false)
        raise ArgumentError, <<~TEXT if address > 0x7FF
          address of turnout can be max 11 bits (2047)
        TEXT

        super()

        @address = address
        @closed = closed
        @status = status
        @reserved = reserved
        @no_command = no_command
      end

      def to_bytestring
        CODE_POINT + pack_parameters
      end

      private

      def pack_parameters
        low, high_and_options = [address].pack('S').bytes

        high_and_options |= 0x80 if closed
        high_and_options |= 0x40 if status
        high_and_options |= 0x20 if reserved
        high_and_options |= 0x10 if no_command

        [low, high_and_options].pack('CC')
      end
    end
  end
end
