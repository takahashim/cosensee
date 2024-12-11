# frozen_string_literal: true

require 'json'

module Cosense
  # for Line
  class Line
    def self.create(obj)
      case obj
      when Array
        obj.map { |arg| new(arg) }
      when String
        new(obj)
      else
        raise Cosense::Error, "invalid data: #{obj}"
      end
    end

    attr_reader :content

    def initialize(content)
      @content = content
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

    def ==(other)
      if other.is_a?(Cosense::Line)
        other.content == content
      else # String
        other == content
      end
    end

    def to_obj
      content
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
