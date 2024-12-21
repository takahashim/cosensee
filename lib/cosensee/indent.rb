# frozen_string_literal: true

require 'json'

module Cosensee
  # for normal Text
  class Indent
    def initialize(content)
      @content = content
      @level = content.size
    end

    attr_reader :content, :level

    def ==(other)
      other.is_a?(Cosensee::Indent) &&
        other.content == content
    end

    def to_obj
      content
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
