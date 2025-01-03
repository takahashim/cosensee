# frozen_string_literal: true

require 'json'

module Cosensee
  # link node
  Link = Data.define(:content) do
    def to_obj
      content
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
