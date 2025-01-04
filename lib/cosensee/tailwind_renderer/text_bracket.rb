# frozen_string_literal: true

require 'cgi/util'

module Cosensee
  class TailwindRenderer
    TextBracket = Data.define(:content) do
      def render
        rendered = TailwindRenderer.new(content: content.content).render
        %(<span>[#{rendered}]</span>)
      end
    end
  end
end
