# frozen_string_literal: true

require 'cgi/util'

module Cosensee
  class TailwindRenderer
    Link = Data.define(:content) do
      def render
        link = content.content
        %(<span><a href="#{CGI.escape_html(link)}">#{CGI.escape_html(link)}</a></span>)
      end
    end
  end
end
