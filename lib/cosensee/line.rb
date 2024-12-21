# frozen_string_literal: true

require 'json'

module Cosensee
  # for Line
  class Line
    def self.create(obj)
      case obj
      when Array
        obj.map { |arg| new(arg) }
      when String
        new(obj)
      else
        raise Cosensee::Error, "invalid data: #{obj}"
      end
    end

    attr_reader :content

    def initialize(content)
      @content = content
      @parsed = LineParser.parse(content)
    end

    def brackets
      content.scan(/\[.+?\]/)
    end

    def some_images?
      brackets.any? { |item| item.match?(/\.(png|jpg)$/) }
    end

    def first_image
      brackets.each do |item|
        return item if item.match?(/\.(png|jpg)$/)
      end
    end

    def indent_level
      content.match(/\A([\t ]*)/)[1].size
    end

    def indented?
      content.match?(/\A[\t ]/)
    end

    def ==(other)
      other.is_a?(Cosensee::Line) &&
        other.content == content
    end

    def to_html
      content
    end

    def to_obj
      content
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
