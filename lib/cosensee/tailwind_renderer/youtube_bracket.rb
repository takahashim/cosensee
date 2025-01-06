# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    YoutubeBracket = Data.define(:content, :project) do
      def render
        %(<iframe class="w-full aspect-video px-8" src="https://www.youtube.com/embed/#{content.video_id}?autoplay=0" type="text/html" allowfullscreen="" scrolling="no" allow="encrypted-media"></iframe>)
      end
    end
  end
end
