# frozen_string_literal: true

module Traincontrol
  module Adapters
    class P50XAdapter
      class UnexpectedStatusError < StandardError; end
      class UnsupportedProtocolError < StandardError; end

      def initialize(serial_tty)
        @device = P50X::Device.new(serial_tty)
        @locomotive_decoders = {}
      end

      def close
        @device.close
      end

      def find_locomotive_decoder(address)
        decoder = lookup_locomotive_decoder(address)
        update_locomotive_decoder_status(decoder)
        @locomotive_decoders[decoder.address] = decoder

        decoder
      end

      def update
        @locomotive_decoders.each_value do |decoder|
          next unless decoder.changed?

          update_locomotive_decoder(decoder)
          decoder.clear_changes
        end
      end

      private

      def lookup_locomotive_decoder(address)
        cfg_command = P50X::Commands::XLokCfg.new(address)
        @device.send(cfg_command)
        raise UnexpectedStatusError, "Unexpected status: #{cfg_command.status}" unless cfg_command.status.ok?

        case cfg_command.response[:protocol]
        when :dcc
          Traincontrol::Decoders::DCCLocomotiveDecoder.new(
            address, speed_steps: cfg_command.response[:speed_steps]
          )
        else
          raise UnsupportedProtocolError, "Locomotive at address #{address} uses unsupported protocol #{cfg_command.response[:protocol]}"
        end
      end

      def update_locomotive_decoder_status(decoder)
        status_command = P50X::Commands::XLokSts.new(decoder.address)
        @device.send(status_command)
        if status_command.status.ok?
          decoder.set_attributes(status_command.response)
        elsif status_command.status.code == :xnodata
          update_locomotive_decoder(decoder)
        else
          raise UnexpectedStatusError, "Unexpected status: #{status_command.status}"
        end
      end

      def update_locomotive_decoder(decoder)
        status = @device.send(
          P50X::Commands::XLok.new(
            decoder.address,
            decoder.speed,
            decoder.direction,
            lights: decoder.lights,
            emergency_stop: decoder.emergency_stop,
            functions: { f1: decoder.f1, f2: decoder.f2, f3: decoder.f3, f4: decoder.f4 }
          )
        )

        raise UnexpectedStatusError, "Unexpected status: #{status_command.status}" unless status.ok?
      end
    end
  end
end
