# frozen_string_literal: true

require 'json'

module Cosensee
  # for codeblock
  Codeblock = Data.define(:content) do
    def to_obj
      "code:#{content}"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
