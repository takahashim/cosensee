# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    FormulaBracket = Data.define(:content) do
      include HtmlEncodable

      def render
        %(<span class="math-container">$#{escape_html(content.formula)}$</span>)
      end
    end
  end
end
