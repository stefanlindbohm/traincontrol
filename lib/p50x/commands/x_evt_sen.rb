# frozen_string_literal: true

module P50X
  module Commands
    class XEvtSen < Base
      CODE_POINT = 0xCB.chr

      attr_reader :response

      def to_bytestring
        CODE_POINT
      end

      def read_response(reader)
        @status = Status::OK
        @response = []

        loop do
          first_byte = reader.read_byte
          break if first_byte.zero?

          bytes = reader.read(2).unshift(first_byte)
          @response << response_attributes(bytes)
        end
      end

      private

      def response_attributes(bytes)
        {
          module_number: bytes[0],
          contacts: [
            bytes[1] & 0x80 == 0x80,
            bytes[1] & 0x40 == 0x40,
            bytes[1] & 0x20 == 0x20,
            bytes[1] & 0x10 == 0x10,
            bytes[1] & 0x08 == 0x08,
            bytes[1] & 0x04 == 0x04,
            bytes[1] & 0x02 == 0x02,
            bytes[1] & 0x01 == 0x01,
            bytes[2] & 0x80 == 0x80,
            bytes[2] & 0x40 == 0x40,
            bytes[2] & 0x20 == 0x20,
            bytes[2] & 0x10 == 0x10,
            bytes[2] & 0x08 == 0x08,
            bytes[2] & 0x04 == 0x04,
            bytes[2] & 0x02 == 0x02,
            bytes[2] & 0x01 == 0x01
          ].freeze
        }.freeze
      end
    end
  end
end
