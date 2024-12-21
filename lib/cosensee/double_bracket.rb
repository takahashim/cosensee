# frozen_string_literal: true

require 'json'

module Cosensee
  # for double Bracket
  class DoubleBracket
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def image?
      @content.match?(/\.(png|jpg)$/)
    end

    def ==(other)
      other.is_a?(Cosensee::DoubleBracket) &&
        other.content == content
    end

    def to_obj
      "[[#{content}]]"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
