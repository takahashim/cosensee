# frozen_string_literal: true

module Cosensee
  module Node
    # for empty bracket
    EmptyBracket = Data.define(:content, :raw) do
      include BracketSerializer
    end
  end
end
