# frozen_string_literal: true

module Cosensee
  # for Icon
  InternalLinkBracket = Data.define(:content, :link, :anchor) do
    include BracketSerializer
  end
end
