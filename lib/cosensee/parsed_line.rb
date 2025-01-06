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
      line_content.is_a?(Cosensee::Codeblock)
    end

    def parsed?
      @parsed
    end

    def rest?
      !!rest
    end

    def first_image
      if line_content?
        line_content.is_a?(Quote) && line_content.content.find { |elem| elem.is_a?(ImageBracket) }
      else
        content.find { |elem| elem.is_a?(ImageBracket) }
      end
    end

    def line_content?
      !!line_content
    end

    def indent_level
      indent.level
    end

    def match(pattern)
      rest.match(pattern)
    end

    def split_rest_by(str)
      rest.split(str, -1)
    end

    def update(**attributes)
      attributes.each do |key, value|
        # Check if the key is a valid accessor
        raise ArgumentError, "Attribute #{key} is not allowed to be updated." unless self.class.method_defined?("#{key}=")

        public_send("#{key}=", value)
      end

      self
    end

    def internal_links
      content.select { |c| c.is_a?(Cosensee::InternalLinkBracket) || c.is_a?(Cosensee::HashTag) }.map(&:anchor)
    end

    def to_s
      raw
    end

    def raw
      if line_content?
        "#{indent.raw}#{line_content.raw}"
      else
        "#{indent.raw}#{content.map(&:to_s).join}"
      end
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
