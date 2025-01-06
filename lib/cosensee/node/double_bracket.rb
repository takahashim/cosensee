# frozen_string_literal: true

module Cosensee
  module Node
    # for double Bracket
    DoubleBracket = Data.define(:content, :raw) do
      def image?
        content.size == 1 && content[0].match?(/\.(png|jpg)$/)
      end

      alias_method :to_s, :raw

      def to_obj
        "[[#{content}]]"
      end

      def to_json(*)
        to_obj.to_json(*)
      end
    end
  end
end
