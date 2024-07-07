# frozen_string_literal: true

module P50X
  module Commands
    class XLokSts < Base
      CODE_POINT = 0x84.chr

      attr_reader :address, :response

      def initialize(address)
        super()

        @address = address
      end

      def to_bytestring
        CODE_POINT + pack_parameters
      end

      def read_response(reader)
        super

        return unless @status.ok?

        bytes = reader.read(3)
        @response = response_attributes(bytes)
      end

      private

      def pack_parameters
        [@address].pack('S')
      end

      def response_attributes(bytes)
        {
          direction: bytes[1] & 0x20 == 0x20 ? :forward : :reverse,
          speed: bytes[2].to_i,
          lights: bytes[1] & 0x10 == 0x10,
          f1: bytes[1] & 0x01 == 0x01,
          f2: bytes[1] & 0x02 == 0x02,
          f3: bytes[1] & 0x04 == 0x04,
          f4: bytes[1] & 0x08 == 0x08
        }.freeze
      end
    end
  end
end
