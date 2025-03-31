# frozen_string_literal: true

module P50X
  module Commands
    class XSensOff < Base
      CODE_POINT = 0x99.chr

      def to_bytestring
        CODE_POINT
      end
    end
  end
end
