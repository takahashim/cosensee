# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    TextBracket = Data.define(:content, :project) do
      def render
        rendered = TailwindRenderer.new(content: content.content, project:).render
        %(<span>[#{rendered}]</span>)
      end
    end
  end
end
