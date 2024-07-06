# frozen_string_literal: true

module P50X
  module Commands
    class XHalt < Base
      CODE_POINT = 0xA5.chr

      def to_bytestring
        CODE_POINT
      end
    end
  end
end
