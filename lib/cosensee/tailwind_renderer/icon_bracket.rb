# frozen_string_literal: true

require 'cgi/util'

module Cosensee
  class TailwindRenderer
    IconBracket = Data.define(:content) do
      def render
        # XXX use icon image finder with project object
        %(<span>[icon:#{CGI.escape_html(content.icon_name)}]</span>)
      end
    end
  end
end
