# frozen_string_literal: true

module Cosensee
  # parser of Bracket
  class BracketParser
    include ::Cosensee::LinkEncodable
    include ::Cosensee::BracketMatchable

    def self.parse(content)
      new.parse(content)
    end

    attr_reader :content

    def parse(content)
      @content = content

      if (matched = match_empty)
        EmptyBracket.new(content:)

      elsif (matched = match_blank)
        blank = matched[1]
        BlankBracket.new(content:, blank:)

      elsif (matched = match_math)
        formula = matched[1]
        FormulaBracket.new(content:, formula:)

      elsif (matched = match_icon)
        icon_name = matched[1]
        IconBracket.new(content:, icon_name:)

      elsif (link, src = match_image)
        ImageBracket.new(content:, link:, src:)

      elsif (matched = match_external_link_precede)
        anchor = matched[3] || matched[1]
        link = matched[1]
        ExternalLinkBracket.new(content:, link:, anchor:)

      elsif (matched = match_external_link_succeed)
        anchor = matched[2] || matched[3]
        link = matched[3]
        ExternalLinkBracket.new(content:, link:, anchor:)

      elsif (matched = match_decorate)
        deco = matched[1]
        text = matched[2]
        font_size = deco.count('*') > 10 ? 10 : deco.count('*')
        underlined = deco.include?('_')
        deleted = deco.include?('-')
        slanted = deco.include?('/')

        DecorateBracket.new(
          content:,
          font_size:,
          underlined:,
          slanted:,
          deleted:,
          text:
        )
      elsif single_text?
        anchor = first_content
        link = "#{encode_link(anchor)}.html"
        InternalLinkBracket.new(content:, link:, anchor:)
      else
        # mixed content
        TextBracket.new(content:)
      end
    end
  end
end
