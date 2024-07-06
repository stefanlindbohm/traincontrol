# frozen_string_literal: true

module P50X
  module Commands
    class XEvtLok < Base
      CODE_POINT = 0xC9.chr

      attr_reader :response

      def to_bytestring
        CODE_POINT
      end

      def read_response(reader)
        @status = Status::OK
        @response = []

        loop do
          first_byte = reader.read_byte
          break if first_byte == 0x80

          bytes = reader.read(4).unshift(first_byte)
          @response << response_attributes(bytes)
        end
      end

      private

      def response_attributes(bytes)
        {
          address: (bytes[2].chr << (bytes[3] & 0x3F).chr).unpack1('S'),
          direction: bytes[3] & 0x80 == 0x80 ? :forward : :reverse,
          speed: bytes[4],
          lights: bytes[3] & 0x40 == 0x40,
          f1: bytes[1] & 0x01 == 0x01,
          f2: bytes[1] & 0x02 == 0x02,
          f3: bytes[1] & 0x04 == 0x04,
          f4: bytes[1] & 0x08 == 0x08,
          f5: bytes[1] & 0x10 == 0x10,
          f6: bytes[1] & 0x20 == 0x20,
          f7: bytes[1] & 0x40 == 0x40,
          f8: bytes[1] & 0x80 == 0x80
        }.freeze
      end
    end
  end
end
