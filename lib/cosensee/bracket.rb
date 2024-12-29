# frozen_string_literal: true

require 'json'

module Cosensee
  # for Bracket
  Bracket = Data.define(:content) do
    # If the content contains Cosensee::Code, the above patterns will not be applied.

    def single_text?
      content.size == 1 && content.is_a?(String)
    end

    def first_content
      content.first
    end

    def image?
      single_text? && first_content.match?(/\.(png|jpg)$/)
    end

    def match_math
      return unless single_text?

      /\A$ (.*)\z/.match(first_content)
    end

    def match_external_link_precede
      return unless single_text?

      %r{\A(https?://.*)(\s.*)?\z}.match(first_content)
    end

    def match_external_link_succeed
      return unless single_text?

      %r{\A((.*\s)?https?://.*)\z}.match(first_content)
    end

    def match_decorate
      return unless single_text?

      %r{\A([_\*/\-"#%&'\(\)~\|\+<>{},\.]+) (.*)\z}.match(first_content)
    end

    def match_icon
      return unless single_text?

      /\A(.*).icon\z/.match(first_content)
    end

    def to_obj
      unparsed = content.map do |elem|
        if elem.is_a?(String)
          elem
        else
          elem.to_obj
        end
      end

      "[#{unparsed}]"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
