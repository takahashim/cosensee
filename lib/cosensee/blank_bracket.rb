# frozen_string_literal: true

module Cosensee
  # for bracket only spaces
  BlankBracket = Data.define(:content, :blank, :raw) do
    include BracketSerializer
  end
end
