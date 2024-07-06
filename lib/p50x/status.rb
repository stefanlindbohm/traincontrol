# frozen_string_literal: true

module P50X
  class Status
    class NotMatchedError < StandardError; end

    attr_reader :error_code, :message

    def self.from_code_point(byte)
      ALL[byte] || (raise NotMatchedError)
    end

    def initialize(error_code = nil, message = nil)
      @error_code = error_code
      @message = message
    end

    def ok?
      error_code.nil?
    end

    def to_s
      return 'OK' if ok?

      "Error #{error_code.upcase}: #{message}"
    end

    ALL = {
      0x0 => OK = new,
      0x06 => new(:xpwoff, 'An error prevented the power from turning on')
    }.freeze
  end
end
