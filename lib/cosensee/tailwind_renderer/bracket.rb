# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    Bracket = Data.define(:content) do
      def render
        case
        when matched = content.match_math
          "<span class='math-container'>$#{matched}$</span>"

        when matched = content.match_external_link_precede
          anchor = if matched[2].empty?
                     matched[1]
                   else
                     matched[2].strip
                   end
          "<span><a href='#{matched[1]}'>#{CGI.escape_html(anchor)}</a></span>"

        when matched = content.match_external_link_succeed
          anchor = if matched[1].empty?
                     matched[2]
                   else
                     matched[1].strip
                   end
          "<span><a href='#{matched[2]}'>#{CGI.escape_html(anchor)}</a></span>"

        when matched = content.match_decorate
          deco = matched[1]
          matched[2]
          strong = deco.count('*') > 10 ? 10 : deco.count('*')
          underlined = deco.include?('_')
          deleted = deco.include?('-')
          slanted = deco.include?('/')

          classes = []
          classes << font_size[strong] if strong
          classes << 'underline' if underlined
          classes << 'italic' if slanted
          classes << 'line-through' if deleted

          '<span class=' # {classes.join(' ')}">#{str}</span>"

        when matched = content.match_icon
          return unless matched

          anchor = if matched[1].empty?
                     matched[2]
                   else
                     matched[1].strip
                   end
          "<span><a href='#{matched[2]}'>#{CGI.escape_html(anchor)}</a></span>"
        else
          link = CGI.escape_html(content.first_content)
          "<span><a href='#{link}'>#{link}</a></span>"
        end
      end

      private

      def font_size
        %w[text-lg text-xl text-2xl text-3xl text-4xl text-5xl text-6xl text-7xl text-8xl text-9xl].freeze
      end
    end
  end
end
