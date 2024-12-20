# frozen_string_literal: true

require 'json'

module Cosensee
  # for Bracket
  class Bracket
    TAG_PATTERN = %r{\A([_\*/\-"#%&'\(\)~\|\+<>{},\.]+) (.*)\z}
    MATH_PATTERN = /\A$ (.*)\z/
    DOUBLE_PATTERN = /\A\[(.*)\]\z/
    HTTP_PATTERN = %r{\A(https?://.*)\z}
    HTTP_RENAME_PATTERN = %r{\A(.*)\s(https?://.*)\z}

    # If the content contains Cosensee::Code, the above patterns will not be applied.

    attr_reader :content

    def initialize(content)
      @content = content
    end

    def image?
      @content.match?(/\.(png|jpg)$/)
    end

    def ==(other)
      if other.is_a?(Cosensee::Bracket)
        other.content == content
      else # String
        other == content
      end
    end

    def to_obj
      "[#{content}]"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
