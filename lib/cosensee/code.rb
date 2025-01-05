# frozen_string_literal: true

require 'json'

module Cosensee
  # parse a line
  Code = Data.define(:content, :raw) do
    def to_s = raw

    def to_obj
      "`#{content}`"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
