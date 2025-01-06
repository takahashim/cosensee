# frozen_string_literal: true

module Cosensee
  module Node
    # for Image
    GyazoImageBracket = Data.define(:content, :link, :src, :image_id, :raw) do
      include BracketSerializer
    end
  end
end
