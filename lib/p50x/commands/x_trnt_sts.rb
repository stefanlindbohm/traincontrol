# frozen_string_literal: true

module P50X
  module Commands
    class XTrntSts < Base
      CODE_POINT = 0x94.chr
      PROTOCOLS = %i[mm sx dcc fmz].freeze

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

        byte = reader.read_byte
        @response = response_attributes(byte)
      end

      private

      def pack_parameters
        [@address].pack('S')
      end

      def response_attributes(byte)
        {
          reserved: byte & 0x02 == 0x02,
          closed: byte & 0x04 == 0x04,
          protocol: PROTOCOLS[(byte & 0x01) + (byte.anybits?(0x08) ? 2 : 0)]
        }.freeze
      end
    end
  end
end
