# frozen_string_literal: true

module Traincontrol
  module Adapters
    class DummyAdapter
      def initialize
        @locomotive_decoders = {}
      end

      def close; end

      def find_locomotive_decoder(address)
        decoder = Traincontrol::Decoders::DCCLocomotiveDecoder.new(address)
        @locomotive_decoders[decoder.address] = decoder

        decoder
      end

      def update
        @locomotive_decoders.each_value do |decoder|
          next unless decoder.changed?

          decoder.clear_changes
        end
      end
    end
  end
end
