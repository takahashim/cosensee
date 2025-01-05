# frozen_string_literal: true

module Cosensee
  # for Formula
  FormulaBracket = Data.define(:content, :formula, :raw) do
    include BracketSerializer
  end
end
