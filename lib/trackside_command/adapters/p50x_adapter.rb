# frozen_string_literal: true

module TracksideCommand
  module Adapters
    class P50XAdapter
      class UnexpectedStatusError < StandardError; end
      class UnsupportedProtocolError < StandardError; end

      def initialize(serial_tty)
        @device = P50X::Device.new(serial_tty)
        @locomotive_decoders = {}
        @accessory_outputs = {}
      end

      def close
        @device.close
      end

      def find_locomotive_decoder(address)
        decoder = lookup_locomotive_decoder(address)
        read_locomotive_decoder(decoder)
        @locomotive_decoders[decoder.address] = decoder

        decoder
      end

      def find_accessory_output(address)
        output = TracksideCommand::AccessoryOutput.new(address)
        read_accessory_output(output)
        @accessory_outputs[output.address] = output

        output
      end

      def update
        @locomotive_decoders.each_value do |decoder|
          next unless decoder.changed?

          update_locomotive_decoder(decoder)
          decoder.clear_changes
        end

        @accessory_outputs.each_value do |output|
          next unless output.changed?

          update_accessory_output(output)
          output.clear_changes
        end
      end

      def check_events
        event_command = P50X::Commands::XEvent.new
        @device.send(event_command, log: false)

        warn "Active events: #{event_command.response[:events].join(', ')}" if event_command.response[:events].any?

        detail_commands = event_command.response[:requested_commands].map(&:new)
        return if detail_commands.empty?

        @device.send(detail_commands)
        detail_commands.each { process_event_command(_1) }
      end

      private

      def process_event_command(command)
        case command
        when P50X::Commands::XEvtLok
          command.response.each { process_locomotive_event_attributes(_1) }
        when P50X::Commands::XStatus
          warn command.response
        end
      end

      def process_locomotive_event_attributes(attributes)
        return unless @locomotive_decoders.key?(attributes[:address])

        decoder = @locomotive_decoders[attributes[:address]]
        decoder.set_attributes(attributes)
      end

      def lookup_locomotive_decoder(address)
        cfg_command = P50X::Commands::XLokCfg.new(address)
        @device.send(cfg_command)
        raise UnexpectedStatusError, "Unexpected status: #{cfg_command.status}" unless cfg_command.status.ok?

        TracksideCommand::LocomotiveDecoder.new(
          address, speed_steps: cfg_command.response[:speed_steps]
        )
      end

      def read_locomotive_decoder(decoder)
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
        lok_command =
          P50X::Commands::XLok.new(
            decoder.address,
            decoder.speed,
            decoder.direction,
            force: true,
            lights: decoder.lights,
            emergency_stop: decoder.emergency_stop,
            functions: { f1: decoder.f1, f2: decoder.f2, f3: decoder.f3, f4: decoder.f4 }
          )
        @device.send(lok_command)

        raise UnexpectedStatusError, "Unexpected status: #{lok_command.status}" unless lok_command.status.ok?
      end

      def read_accessory_output(output)
        status_command = P50X::Commands::XTrntSts.new(output.address)
        @device.send(status_command)
        if status_command.status.ok?
          output.set_attributes(
            thrown: !status_command.response[:closed]
          )
        else
          raise UnexpectedStatusError, "Unexpected status: #{status_command.status}"
        end
      rescue => e
        binding.debugger
      end

      def update_accessory_output(output)
        turnout_command =
          P50X::Commands::XTrnt.new(
            output.address,
            !output.thrown,
            output.active
          )
        @device.send(turnout_command)

        raise UnexpectedStatusError, "Unexpected status: #{turnout_command.status}" unless turnout_command.status.ok?
      end
    end
  end
end
