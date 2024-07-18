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
      @uart_mutex = Mutex.new
      @reader = Reader.new(@uart)
    end

    def close
      @uart.close
    end

    def send(commands, log: true)
      commands = [commands] unless commands.is_a?(Array)

      @uart_mutex.synchronize do
        commands.each do |command|
          $stderr.print "#{command}... " if log
          @uart.write(P50X_LEAD_CHAR + command.to_bytestring)
        end

        commands.each do |command|
          command.read_response(@reader)
          $stderr.print "#{command.status} " if log
        end

        $stderr.puts if log
      end
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
