# frozen_string_literal: true

require 'cgi/util'

module Cosensee
  class TailwindRenderer
    FormulaBracket = Data.define(:content) do
      def render
        %(<span class="math-container">$#{CGI.escape_html(content.formula)}$</span>)
      end
    end
  end
end
