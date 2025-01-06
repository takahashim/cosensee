# frozen_string_literal: true

module Cosensee
  module Node
    # for Formula
    ExternalLinkBracket = Data.define(:content, :link, :anchor, :raw) do
      include BracketSerializer
    end
  end
end
