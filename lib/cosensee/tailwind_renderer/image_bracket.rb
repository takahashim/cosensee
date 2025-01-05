# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    ImageBracket = Data.define(:content) do
      def render
        if content.link
          %(<span><a href="#{content.link}"><img src="#{content.src}" class="max-w-max max-h-80"></a></span>)
        else
          %(<span><img src="#{content.src}" class="max-w-max max-h-80"></span>)
        end
      end
    end
  end
end
