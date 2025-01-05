# frozen_string_literal: true

require 'json'

module Cosensee
  # for quote
  Quote = Data.define(:content, :raw, :mark) do
    def replace_content(new_content)
      Quote.new(content: new_content, raw:, mark:)
    end

    def to_s = raw

    def to_obj
      content
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
