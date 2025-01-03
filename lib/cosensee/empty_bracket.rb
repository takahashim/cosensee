# frozen_string_literal: true

require 'json'

module Cosensee
  # for empty bracket
  EmptyBracket = Data.define(:content) do
    include BracketSerializer
  end
end
