# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    GyazoImageBracket = Data.define(:content, :project) do
      def render
        if content.link
          %(<span><a href="#{content.link}"><img loading="lazy" src="https://gyazo.com/#{content.image_id}/raw" class="max-w-max max-h-80"></a></span>)
        else
          %(<span><img loading="lazy" src="https://gyazo.com/#{content.image_id}/raw" class="max-w-max max-h-80"></span>)
        end
      end
    end
  end
end
