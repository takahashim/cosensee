# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    SpotifyPlaylistBracket = Data.define(:content, :project) do
      def render
        %(<iframe src="https://open.spotify.com/embed/playlist/#{content.playlist_id}" class="w-full h-96" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>)
      end
    end
  end
end
