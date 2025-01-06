# frozen_string_literal: true

module Cosensee
  module Node
    # for Icon
    InternalLinkBracket = Data.define(:content, :link, :anchor, :raw) do
      include BracketSerializer
    end
  end
end
