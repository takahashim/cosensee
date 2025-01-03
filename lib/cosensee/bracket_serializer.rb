# frozen_string_literal: true

module Cosensee
  module BracketSerializer
    def to_obj
      unparsed = content.map do |elem|
        if elem.is_a?(String)
          elem
        else
          elem.to_obj
        end
      end

      "[#{unparsed}]"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
