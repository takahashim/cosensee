# frozen_string_literal: true

require 'json'

module Cosensee
  # for blockquote
  class Blockquote
    def initialize(content)
      @content = content
    end

    attr_reader :content

    def ==(other)
      if other.is_a?(Cosensee::Blockquote)
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
