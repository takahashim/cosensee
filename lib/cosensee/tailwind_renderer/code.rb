# frozen_string_literal: true

require 'cgi/util'

module Cosensee
  class TailwindRenderer
    Code = Data.define(:content) do
      def render
        code = content.content
        "<code class=\"bg-gray-100 text-red-500 px-1 py-0.5 rounded\">#{CGI.escape_html(code)}</code>"
      end
    end
  end
end
