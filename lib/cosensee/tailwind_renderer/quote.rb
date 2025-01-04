# frozen_string_literal: true

require 'json'

module Cosensee
  class TailwindRenderer
    Quote = Data.define(:content) do
      def render
        code = content.content
        %(<blockquote class="border-l-4 border-gray-300 bg-gray-100 px-4 text-gray-800">#{CGI.escape_html(code)}</blockquote>)
      end
    end
  end
end
