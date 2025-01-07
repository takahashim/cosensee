# frozen_string_literal: true

module Cosensee
  module Node
    # for Spotify Playlist
    SpotifyPlaylistBracket = Data.define(:content, :src, :playlist_id, :raw) do
      include BracketSerializer
    end
  end
end
