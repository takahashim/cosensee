# frozen_string_literal: true

module Cosensee
  # for empty bracket
  EmptyBracket = Data.define(:content, :raw) do
    include BracketSerializer
  end
end
