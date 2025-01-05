# frozen_string_literal: true

module Cosensee
  # for Image
  YoutubeBracket = Data.define(:content, :video_id, :raw) do
    include BracketSerializer
  end
end
