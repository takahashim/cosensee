# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    Link = Data.define(:content, :project) do
      include HtmlEncodable

      def render
        link = content.content
        %(<span><a href="#{escape_html(link)}" class="text-blue-500 hover:text-blue-700">#{escape_html(link)}</a></span>)
      end
    end
  end
end
