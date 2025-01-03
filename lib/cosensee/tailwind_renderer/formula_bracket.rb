# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    FormulaBracket = Data.define(:bracket) do
      def render
        %(<span class="math-container">$#{bracket.formula}$</span>)
      end
    end
  end
end
