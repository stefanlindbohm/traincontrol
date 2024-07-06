# frozen_string_literal: true

module P50X
  module Commands
    class XPwrOff < Base
      CODE_POINT = 0xA6.chr

      def to_bytestring
        CODE_POINT
      end
    end
  end
end
