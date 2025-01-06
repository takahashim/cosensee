# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    EmptyBracket = Data.define(:content, :project) do
      def render
        %(<span>[]</span>)
      end
    end
  end
end
