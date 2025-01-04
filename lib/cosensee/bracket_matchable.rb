# frozen_string_literal: true

# XXX: remove this file
module Cosensee
  # matchers of Bracket
  module BracketMatchable
    # If the content contains Cosensee::Code, the above patterns will not be applied.
    def single_text?
      content.size == 1 && content[0].is_a?(String)
    end

    def first_content
      content.first
    end

    def image?
      single_text? && first_content.match?(/\.(png|jpg)$/)
    end

    def match_empty
      return unless single_text?

      /\A\z/.match(first_content)
    end

    def match_blank
      return unless single_text?

      /\A([ \t])+\z/.match(first_content)
    end

    def match_math
      return unless single_text?

      /\A\$ (.*)\z/.match(first_content)
    end

    def match_external_link_precede
      return unless single_text?

      %r{\A(https?://[^ \t]*)(\s+(.+))?\z}.match(first_content)
    end

    def match_external_link_succeed
      return unless single_text?

      %r{\A((.*\S)\s+)?(https?://[^\s]+)\z}.match(first_content)
    end

    def match_decorate
      return unless single_text?

      %r{\A([_\*/\-"#%&'\(\)~\|\+<>{},\.]+) (.+)\z}.match(first_content)
    end

    def match_icon
      return unless single_text?

      /\A(.*).icon\z/.match(first_content)
    end

    def match_image
      return unless single_text?

      if (matched = link_first_image_regexp.match(first_content))
        [matched[1], matched[2]]
      elsif (matched = src_first_image_regexp.match(first_content))
        [matched[4], matched[1]]
      end
    end

    def image_url_regexp
      %r{\A(https?://[^\s\]]*\.(png|jpe?g|gif|svg|webp)(\?[^\s\]]+)?)\z}
    end

    def link_first_image_regexp
      %r{\A(https?://[^\s]+)\s+(https?://[^\s\]]*\.(png|jpe?g|gif|svg|webp)(\?[^\s\]]+)?)\z}
    end

    def src_first_image_regexp
      %r{\A(https?://[^\s\]]*\.(png|jpe?g|gif|svg|webp)(\?[^\s\]]+)?)\s+(https?://[^\s]+)\z}
    end
  end
end
