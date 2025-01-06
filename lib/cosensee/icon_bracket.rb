# frozen_string_literal: true

module Cosensee
  # for Icon
  IconBracket = Data.define(:content, :icon_name, :raw) do
    include BracketSerializer
  end
end
