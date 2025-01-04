# frozen_string_literal: true

module Cosensee
  # parse a line
  class ParsedBracket
    def initialize(content: [])
      @content = content
      @parsed = false
    end

    attr_accessor :content

    def parsed?
      @parsed
    end

    def single_text?
      content.size == 1 && content.first.is_a?(String)
    end

    def first_content
      content.first
    end

    def ==(other)
      other.is_a?(Cosensee::ParsedBracket) &&
        other.content == content &&
        other.parsed? == parsed?
    end
  end
end
