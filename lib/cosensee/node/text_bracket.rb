# frozen_string_literal: true

require 'json'

module Cosensee
  module Node
    # for mixed content (!= single text)
    TextBracket = Data.define(:content, :raw) do
      include BracketSerializer
    end
  end
end
