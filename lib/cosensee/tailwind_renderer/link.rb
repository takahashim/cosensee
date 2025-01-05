# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    Link = Data.define(:content) do
      include HtmlEncodable

      def render
        link = content.content
        %(<span><a href="#{escape_html(link)}">#{escape_html(link)}</a></span>)
      end
    end
  end
end
