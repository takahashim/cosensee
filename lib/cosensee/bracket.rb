# frozen_string_literal: true

require 'json'

module Cosensee
  # for Bracket
  Bracket = Data.define(:content) do
    # If the content contains Cosensee::Code, the above patterns will not be applied.

    def image?
      content.match?(/\.(png|jpg)$/)
    end

    def match_math
      /\A$ (.*)\z/.match(content)
    end

    def match_external_link_precede
      %r{\A(https?://.*)(\s.*)?\z}.match(content)
    end

    def match_external_link_succeed
      %r{\A((.*\s)?https?://.*)\z}.match(content)
    end

    def match_decorate
      %r{\A([_\*/\-"#%&'\(\)~\|\+<>{},\.]+) (.*)\z}.match(content)
    end

    def match_icon
      /\A(.*).icon\z/.match(content)
    end

    def to_obj
      "[#{content}]"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
