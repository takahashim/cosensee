# frozen_string_literal: true

require 'json'

module Cosensee
  # for Icon
  IconBracket = Data.define(:content, :icon_name) do
    include BracketSerializer
  end
end
