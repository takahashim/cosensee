# frozen_string_literal: true

require 'uri'

module Cosensee
  class TailwindRenderer
    InternalLinkBracket = Data.define(:content, :project) do
      include HtmlEncodable

      def render
        %(<span><a href="#{content.link}" class="text-blue-500 hover:text-blue-700">#{escape_html(content.anchor)}</a></span>)
      end
    end
  end
end
