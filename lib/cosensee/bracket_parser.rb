# frozen_string_literal: true

module Cosensee
  # parser of Bracket
  class BracketParser
    include ::Cosensee::LinkEncodable

    def self.parse(content)
      new.parse(content)
    end

    attr_reader :content

    def parse(content)
      @content = content

      case content
      in [/\A\z/]
        EmptyBracket.new(content:, raw: '[]')
      in [/\A([ \t]+)\z/]
        BlankBracket.new(content:, blank: Regexp.last_match(1), raw: "[#{Regexp.last_match(0)}]")
      in [/\A\$ (.*)\z/]
        FormulaBracket.new(content:, formula: Regexp.last_match(1), raw: "[#{Regexp.last_match(0)}]")
      in [/\A(.*).icon\z/]
        IconBracket.new(content:, icon_name: Regexp.last_match(1), raw: Regexp.last_match(0))
      in [%r{\A(https://www\.youtube\.com/watch\?v=([^&]+)(&.*)?)\z}]
        YoutubeBracket.new(content:, video_id: Regexp.last_match(2), raw: "[#{Regexp.last_match(0)}]")
      in [%r{\A(https?://[^\s]+)\s+(https?://[^\s\]]*\.(png|jpe?g|gif|svg|webp)(\?[^\s\]]+)?)\z}]
        ImageBracket.new(content:, link: Regexp.last_match(1), src: Regexp.last_match(2), raw: "[#{Regexp.last_match(0)}]")
      in [%r{\A(https?://[^\s\]]*\.(png|jpe?g|gif|svg|webp)(\?[^\s\]]+)?)\s+(https?://[^\s]+)\z}]
        ImageBracket.new(content:, link: Regexp.last_match(4), src: Regexp.last_match(1), raw: "[#{Regexp.last_match(0)}]")
      in [%r{\A(https?://[^\s\]]*\.(png|jpe?g|gif|svg|webp))\z}] | [%r{\A(https://gyazo.com/[0-9a-f]{32}(?:/raw)?)\z}]
        ImageBracket.new(content:, link: nil, src: Regexp.last_match(1), raw: "[#{Regexp.last_match(0)}]")
      in [%r{\A(https?://[^ \t]*)(\s+(.+))?\z}]
        # match_external_link_precede
        anchor = Regexp.last_match(3) || Regexp.last_match(1)
        link = Regexp.last_match(1)
        raw = "[#{Regexp.last_match(0)}]"
        ExternalLinkBracket.new(content:, link:, anchor:, raw:)
      in [%r{\A((.*\S)\s+)?(https?://[^\s]+)\z}]
        # match_external_link_succeed
        anchor = Regexp.last_match(2) || Regexp.last_match(3)
        link = Regexp.last_match(3)
        raw = "[#{Regexp.last_match(0)}]"
        ExternalLinkBracket.new(content:, link:, anchor:, raw:)
      in [%r{\A([_\*/\-"#%&'\(\)~\|\+<>{},\.]+) (.+)\z}]
        # match_decorate
        deco = Regexp.last_match(1)
        text = Regexp.last_match(2)
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
          text:,
          raw:
        )
      else
        line_parser = LineParser.new
        data = ParsedBracket.new(content:)
        parsed = data
                   .then { |d| line_parser.parse_url(d) }
                   .then { |d| line_parser.parse_hashtag(d) }
        if parsed.single_text? && parsed.content == content
          anchor = parsed.first_content
          link = make_link(anchor)
          raw = raw_string
          InternalLinkBracket.new(content:, link:, anchor:, raw:)
        else
          TextBracket.new(content: parsed.content, raw: raw_string)
        end
      end
    end

    def raw_string
      "[#{content.map(&:to_s).join}]"
    end
  end
end
