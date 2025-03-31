# frozen_string_literal: true

module P50X
  module Commands
    class XStatus < Base
      CODE_POINT = 0xA2.chr

      attr_reader :response

      def to_bytestring
        CODE_POINT
      end

      def read_response(reader)
        @status = Status::OK

        byte = reader.read_byte

        @response = response_attributes(byte)
      end

      private

      def response_attributes(byte)
        {
          voltage_regulation: byte & 0x40 == 0x40,
          external_central_unit_present: byte & 0x20 == 0x20,
          halt: byte & 0x10 == 0x10,
          power_on: byte & 0x08 == 0x08,
          overheating_condition: byte & 0x04 == 0x04,
          go_pressed_externally: byte & 0x02 == 0x02,
          stop_pressed_externally: byte & 0x01 == 0x01
        }.freeze
      end
    end
  end
end
