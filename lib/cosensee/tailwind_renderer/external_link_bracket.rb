# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    ExternalLinkBracket = Data.define(:content) do
      include HtmlEncodable

      def render
        link = content.link
        anchor = content.anchor || content.link
        %(<span><a href="#{link}" class="text-blue-500 hover:text-blue-700">#{escape_html(anchor)}</a></span>)
      end
    end
  end
end
