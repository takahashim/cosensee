# frozen_string_literal: true

module Cosensee
  # for Formula
  FormulaBracket = Data.define(:content, :formula) do
    include BracketSerializer
  end
end
