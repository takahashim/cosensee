# frozen_string_literal: true

require 'json'

module Cosensee
  # for Line
  Line = Data.define(:content, :parsed) do
    def self.from_array(lines_args)
      lines_args.map { |arg| new(arg) }
    end

    def initialize(content:)
      super(
        content:,
        parsed: LineParser.parse(content)
      )
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

    def to_obj
      content
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
