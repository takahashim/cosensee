# frozen_string_literal: true

require 'json'

module Cosensee
  # for normal Text
  Indent = Data.define(:content) do
    def level
      @level ||= content.size
    end

    def to_obj
      content
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
