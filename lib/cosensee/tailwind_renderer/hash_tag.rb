# frozen_string_literal: true

require 'uri'

module Cosensee
  class TailwindRenderer
    HashTag = Data.define(:content) do
      def render
        hash_tag = content.content
        %(<span><a href="#{CGI.escape_html(hash_tag)}">##{CGI.escape_html(hash_tag)}</a></span>)
      end
    end
  end
end
