# frozen_string_literal: true

module Cosensee
  module Node
    # for Image
    YoutubeBracket = Data.define(:content, :video_id, :raw) do
      include BracketSerializer
    end
  end
end
