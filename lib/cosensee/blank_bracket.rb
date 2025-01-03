# frozen_string_literal: true

require 'json'

module Cosensee
  # for bracket only spaces
  BlankBracket = Data.define(:content, :blank) do
    include BracketSerializer
  end
end
