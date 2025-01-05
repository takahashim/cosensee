# frozen_string_literal: true

require 'uri'

module Cosensee
  class TailwindRenderer
    InternalLinkBracket = Data.define(:content) do
      include HtmlEncodable

      def render
        %(<span><a href="#{content.link}">#{escape_html(content.anchor)}</a></span>)
      end
    end
  end
end
