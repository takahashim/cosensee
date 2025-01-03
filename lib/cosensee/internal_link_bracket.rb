# frozen_string_literal: true

require 'json'

module Cosensee
  # for Icon
  InternalLinkBracket = Data.define(:content, :link, :anchor) do
    include BracketSerializer
  end
end
