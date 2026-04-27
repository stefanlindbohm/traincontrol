# frozen_string_literal: true

module TracksideCommand
  module Adapters
    class DummyAdapter
      def initialize
        @locomotive_decoders = {}
        @accessory_outputs = {}
      end

      def close; end

      def find_locomotive_decoder(address)
        decoder = TracksideCommand::Decoders::DCCLocomotiveDecoder.new(address)
        @locomotive_decoders[decoder.address] = decoder

        decoder
      end

      def find_accessory_output(address)
        output = TracksideCommand::Decoders::AccessoryOutput.new(address)
        @accessory_outputs[output.address] = output

        output
      end

      def update
        @locomotive_decoders.each_value do |decoder|
          next unless decoder.changed?

          decoder.clear_changes
        end

        @accessory_outputs.each_value do |output|
          next unless output.changed?

          output.clear_changes
        end
      end

      def check_events; end
    end
  end
end
