# frozen_string_literal: true

module Cosensee
  module Node
    # for Formula
    FormulaBracket = Data.define(:content, :formula, :raw) do
      include BracketSerializer
    end
  end
end
