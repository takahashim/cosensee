# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    BlankBracket = Data.define(:content, :project) do
      def render
        %(<span>#{content.blank}</span>)
      end
    end
  end
end
