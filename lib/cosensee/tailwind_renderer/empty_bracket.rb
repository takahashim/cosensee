# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    EmptyBracket = Data.define(:content) do
      def render
        %(<span>[]</span>)
      end
    end
  end
end
