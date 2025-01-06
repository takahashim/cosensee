# frozen_string_literal: true

module Cosensee
  module Node
    # for Decorate
    DecorateBracket = Data.define(
      :content,
      :font_size,
      :underlined,
      :slanted,
      :deleted,
      :text,
      :raw
    ) do
      include BracketSerializer
    end
  end
end
