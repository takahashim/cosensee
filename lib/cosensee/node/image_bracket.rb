# frozen_string_literal: true

module Cosensee
  module Node
    # for Image
    ImageBracket = Data.define(:content, :link, :src, :raw) do
      include BracketSerializer
    end
  end
end
