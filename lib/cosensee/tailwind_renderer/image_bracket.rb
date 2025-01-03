# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    ImageBracket = Data.define(:content) do
      def render
        if content.link
          %(<span><a href="#{content.link}"><img src="#{content.src}"></a></span>)
        else
          %(<span><img src="#{content.src}"></span>)
        end
      end
    end
  end
end
