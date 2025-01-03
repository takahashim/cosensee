# frozen_string_literal: true

module Cosensee
  # parse a line
  class ParsedLine
    def initialize(indent:, line_content: nil, content: [])
      @indent = indent
      @line_content = line_content
      @content = content
    end

    attr_reader :indent, :line_content, :content

    def ==(other)
      other.is_a?(Cosensee::ParsedLine) &&
        other.indent == indent &&
        other.line_content == line_content &&
        other.content == content
    end
  end
end
