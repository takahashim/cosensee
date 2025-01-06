# frozen_string_literal: true

module Cosensee
  # for Image
  GyazoImageBracket = Data.define(:content, :link, :src, :image_id, :raw) do
    include BracketSerializer
  end
end
