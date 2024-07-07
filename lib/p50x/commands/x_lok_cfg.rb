# frozen_string_literal: true

module P50X
  module Commands
    class XLokCfg < Base
      CODE_POINT = 0x85.chr

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

        bytes = reader.read(4)
        @response = response_attributes(bytes)
      end

      private

      def pack_parameters
        [@address].pack('S')
      end

      def response_attributes(bytes)
        {
          protocol:
            case bytes[0]
            when 0
              :mm
            when 1
              :sx
            when 2
              :dcc
            when 3
              :fmz
            end,
          speed_steps: bytes[1]
        }.freeze
      end
    end
  end
end
