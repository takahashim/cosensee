# frozen_string_literal: true

module Cosensee
  # for Image
  ImageBracket = Data.define(:content, :link, :src) do
    include BracketSerializer
  end
end
