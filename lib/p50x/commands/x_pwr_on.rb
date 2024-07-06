# frozen_string_literal: true

module P50X
  module Commands
    class XPwrOn < Base
      CODE_POINT = 0xA7.chr

      def to_bytestring
        CODE_POINT
      end
    end
  end
end
