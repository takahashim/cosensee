# frozen_string_literal: true

require 'json'

module Cosensee
  class TailwindRenderer
    CommandLine = Data.define(:content) do
      def render
        code = content.content
        prompt = content.prompt
        %(<code class="bg-gray-100 text-gray-800 px-4"><span class="text-red-400">#{prompt}</span>#{CGI.escape_html(code)}</code>)
      end
    end
  end
end
