# frozen_string_literal: true

require 'json'

module Cosensee
  # for mixed content (!= single text)
  TextBracket = Data.define(:content) do
    include BracketSerializer
  end
end
