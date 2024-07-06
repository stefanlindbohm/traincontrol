# frozen_string_literal: true

require 'uart'

# Monkey patch for changing timeout in UART gem.
# TODO: Submit a PR to add this functionality.
module UART
  def read_timeout(termios, _val)
    termios.cc[Termios::VTIME] = 50 # This line is not configurable from the outside
    termios.cc[Termios::VMIN] = 0
    termios
  end
  module_function :read_timeout
end

module P50X
  class Device
    P50X_LEAD_CHAR = 'X'

    def initialize(serial_tty)
      @uart = UART.open(serial_tty, 19_200, '8N2')
      @reader = Reader.new(@uart)
    end

    def close
      @uart.close
    end

    def send(command, log: true)
      $stderr.print "#{command}... " if log
      @uart.write(P50X_LEAD_CHAR + command.to_bytestring)
      command.read_response(@reader)
      $stderr.puts command.status if log
      command
    end

    class Reader
      class TimeoutError < StandardError; end

      def initialize(uart)
        @uart = uart
      end

      def read(length)
        bytes = @uart.read(length)&.bytes

        raise TimeoutError, 'Timeout waiting for expected number of bytes' if (bytes&.count || 0) < length

        bytes
      end

      def read_byte
        read(1).first
      end
    end
  end
end
