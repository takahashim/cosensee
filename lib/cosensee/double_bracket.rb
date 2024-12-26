# frozen_string_literal: true

require 'json'

module Cosensee
  # for double Bracket
  DoubleBracket = Data.define(:content) do
    def image?
      @content.match?(/\.(png|jpg)$/)
    end

    def to_obj
      "[[#{content}]]"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
