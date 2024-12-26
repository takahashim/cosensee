# frozen_string_literal: true

require 'json'

module Cosensee
  # for Bracket
  Bracket = Data.define(:content) do
    DECORATE_PATTERN = %r{\A([_\*/\-"#%&'\(\)~\|\+<>{},\.]+) (.*)\z}
    MATH_PATTERN = /\A$ (.*)\z/
    HTTP_PATTERN = %r{\A(https?://.*)(\s.*)?\z}
    HTTP_PATTERN2 = %r{\A((.*\s)?https?://.*)\z}
    ICON_PATTERN = /\A(.*).icon\z/

    # If the content contains Cosensee::Code, the above patterns will not be applied.

    def image?
      @content.match?(/\.(png|jpg)$/)
    end

    def match_math
      MATH_PATTERN.match(content)
    end

    def match_external_link_precede
      HTTP_PATTERN.match(content)
    end

    def match_external_link_succeed
      HTTP_PATTERN2.match(content)
    end

    def match_decorate
      DECORATE_PATTERN.match(content)
    end

    def match_icon
      ICON_PATTERN.match(content)
    end

    def to_obj
      "[#{content}]"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
