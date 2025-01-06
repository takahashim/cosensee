# frozen_string_literal: true

require 'json'

module Cosensee
  module Node
    # parse a line
    Code = Data.define(:content, :raw) do
      alias_method :to_s, :raw

      def to_obj
        "`#{content}`"
      end

      def to_json(*)
        to_obj.to_json(*)
      end
    end
  end
end
