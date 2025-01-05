# frozen_string_literal: true

module Cosensee
  # for Image
  ImageBracket = Data.define(:content, :link, :src, :raw) do
    include BracketSerializer
  end
end
