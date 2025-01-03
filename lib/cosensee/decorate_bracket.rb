# frozen_string_literal: true

require 'json'

module Cosensee
  # for Decorate
  DecorateBracket = Data.define(
    :content,
    :font_size,
    :underlined,
    :slanted,
    :deleted,
    :text
  ) do
    include BracketSerializer
  end
end
