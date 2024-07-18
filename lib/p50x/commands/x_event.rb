# frozen_string_literal: true

module P50X
  module Commands
    class XEvent < Base
      CODE_POINT = 0xC8.chr

      attr_reader :response

      def to_bytestring
        CODE_POINT
      end

      def read_response(reader)
        @status = Status::OK

        bytes = []
        loop do
          byte = reader.read_byte
          bytes << byte
          break unless byte & 0x80 == 0x80
        end

        @response = response_attributes(bytes)
      end

      private

      def response_attributes(bytes)
        # Missing bytes can be assumed to be zero
        first, second, third = bytes
        second ||= 0
        third ||= 0

        requested_commands = []
        unsupported_requested_commands = []
        events = []

        # Commands requested by the P50X device that we support
        requested_commands << XEvtLok if first & 0x01 == 0x01
        unsupported_requested_commands << :sensors if first & 0x04 == 0x04 # TODO: XEvtSen
        unsupported_requested_commands << :turnouts if first & 0x20 == 0x20 # TODO: XEvtTrn
        unsupported_requested_commands << :issue_xstatus if second & 0x40 == 0x40 # TODO: XStatus

        # Commands requested by the P50X device that we don't support, no
        # action is possible but reporting might help debugging
        unsupported_requested_commands << :xevtir if first & 0x02 == 0x02 # Unsupported command (XEvtIR)
        unsupported_requested_commands << :xevtpt if third & 0x01 == 0x01 # Unsupported command, for now (XEvtPT)
        unsupported_requested_commands << :xevttkr if third & 0x08 == 0x08 # Undocumented command in P50X (XEvtTkR)

        # Event notices that don't require further commands
        events << :power_off if first & 0x08 == 0x08
        events << :reserved_turnouts if first & 0x10 == 0x10
        events << :external_short if second & 0x01 == 0x01
        events << :lokmaus_short if second & 0x02 == 0x02
        events << :internal_short if second & 0x04 == 0x04
        events << :other_short if second & 0x08 == 0x08
        events << :pt_layout_connection if second & 0x10 == 0x10
        events << :overheating if second & 0x20 == 0x20
        events << :rs232_overflow if third & 0x02 == 0x02
        events << :memory_events if third & 0x04 == 0x04
        events << :external_voltage if third & 0x10 == 0x10

        { requested_commands:, unsupported_requested_commands:, events: }
      end
    end
  end
end
