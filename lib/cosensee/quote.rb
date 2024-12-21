# frozen_string_literal: true

require 'json'

module Cosensee
  # for quote
  class Quote
    def initialize(content)
      @content = content
    end

    attr_reader :content

    def ==(other)
      other.is_a?(Cosensee::Quote) &&
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
