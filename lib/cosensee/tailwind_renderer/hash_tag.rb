# frozen_string_literal: true

require 'uri'

module Cosensee
  class TailwindRenderer
    HashTag = Data.define(:content) do
      include LinkEncodable
      include HtmlEncodable

      def render
        hash_tag = content.content
        %(<span><a href="#{make_link(hash_tag)}" class="text-blue-500 hover:text-blue-700">##{escape_html(hash_tag)}</a></span>)
      end
    end
  end
end
