# frozen_string_literal: true

require 'json'

module Cosensee
  # for normal Text
  Indent = Data.define(:content) do
    def initialize(content: '')
      @level = content.size
      super
    end

    attr_reader :level

    def to_obj
      content
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
