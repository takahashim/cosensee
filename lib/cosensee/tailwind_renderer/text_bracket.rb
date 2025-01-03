# frozen_string_literal: true

require 'cgi/util'

module Cosensee
  class TailwindRenderer
    TextBracket = Data.define(:content) do
      def render
        content.map do |c|
          if c.is_a?(String)
            CGI.escape_html(c)
          else
            TailwindRenderer.new(c).render
          end
        end
        %(<span>[#{c.join}]</span>)
      end
    end
  end
end
