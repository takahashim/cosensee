# frozen_string_literal: true

module Cosensee
  # parse a line
  class ParsedLine
    def initialize(indent: nil, line_content: nil, content: [], rest: nil, parsed: false)
      @indent = indent
      @line_content = line_content
      @content = content
      @rest = rest
      @parsed = parsed
    end

    attr_accessor :indent, :line_content, :content, :rest, :parsed

    def codeblock?
      line_content.is_a?(Cosensee::CodeBlock)
    end

    def parsed?
      @parsed
    end

    def rest?
      !!rest
    end

    def line_content?
      !!line_content
    end

    def indent_level
      indent.level
    end

    def ==(other)
      other.is_a?(Cosensee::ParsedLine) &&
        other.indent == indent &&
        other.line_content == line_content &&
        other.content == content &&
        other.rest == rest &&
        other.parsed? == parsed?
    end
  end
end
