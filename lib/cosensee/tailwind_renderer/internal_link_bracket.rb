# frozen_string_literal: true

require 'uri'

module Cosensee
  class TailwindRenderer
    InternalLinkBracket = Data.define(:content) do
      def render
        %(<span><a href="#{content.link}">#{CGI.escape_html(content.anchor)}</a></span>)
      end
    end
  end
end
