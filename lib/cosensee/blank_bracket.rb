# frozen_string_literal: true

module Cosensee
  # for bracket only spaces
  BlankBracket = Data.define(:content, :blank) do
    include BracketSerializer
  end
end
