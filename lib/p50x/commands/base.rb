# frozen_string_literal: true

module P50X
  module Commands
    class Base
      attr_reader :status

      def read_response(reader)
        @status = Status.from_code_point(reader.read_byte)
      end

      def to_s
        self.class.to_s.split('::').last
      end
    end
  end
end
