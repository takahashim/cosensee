# frozen_string_literal: true

require 'uri'

module Cosensee
  class TailwindRenderer
    HashTag = Data.define(:content) do
      include LinkEncodable
      include HtmlEncodable

      def render
        hash_tag = content.content
        %(<span><a href="#{make_link(hash_tag)}">##{escape_html(hash_tag)}</a></span>)
      end
    end
  end
end
