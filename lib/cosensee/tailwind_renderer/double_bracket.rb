# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    DoubleBracket = Data.define(:content, :project) do
      def render
        rendered_content = Cosensee::TailwindRenderer.new(content: content.content, project:).render

        %(<span class="font-bold">#{rendered_content}</span>)
      end
    end
  end
end
