# frozen_string_literal: true

module P50X
  class Status
    class CodeUnknownError < StandardError; end

    attr_reader :code, :message, :level

    def self.from_code_point(byte)
      ALL[byte] || (raise CodeUnknownError, "Code 0x#{format('%02X', byte)} unknown")
    end

    def initialize(code = nil, level = nil, message = nil)
      @code = code
      @level = level
      @message = message
    end

    def ok?
      level.nil? || level == :warning
    end

    def to_s
      return 'OK' if code.nil?

      "#{level.upcase} #{code.upcase}: #{message}"
    end

    ALL = {
      0x0 => OK = new,
      0x02 => new(:xbadprm, :error, 'Illegal parameter value'),
      0x06 => new(:xpwoff, :error, 'An error prevented the power from turning on'),
      0x08 => new(:xnolspc, :error, 'There is no space in the Lok cmd buffer, please try later'),
      0x0A => new(:xnodata, :error, 'No locomotive status available (Locomotive is not in a slot)'),
      0x0B => new(:xnoslot, :error, 'There is no slot available'),
      0x0C => new(:xbadlnp, :error, 'Address is illegal for this protocol'),
      0x0D => new(:xbadlnp, :error, 'Locomotive already controlled by another device'),
      0x41 => new(:xlkhalt, :warning, 'Command accepted (Lok status updated), but IB in Halt mode'),
      0x42 => new(:xlkpoff, :warning, 'Command accepted (Lok status updated), but IB in Power Off')
    }.freeze
  end
end
