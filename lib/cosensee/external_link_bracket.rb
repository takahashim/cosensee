# frozen_string_literal: true

module Cosensee
  # for Formula
  ExternalLinkBracket = Data.define(:content, :link, :anchor) do
    include BracketSerializer
  end
end
