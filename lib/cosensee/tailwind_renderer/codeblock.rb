# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    # codeblock renderer
    Codeblock = Data.define(:content, :project) do
      include HtmlEncodable

      def render
        title = content.name

        # !!! EXTENSION: if name ends with .svgtext, render as inline SVG text
        return InlineSvgText.new(content:, project:).render if title.match?(/\.svgtext$/)

        <<~HTML_BLOCK
          <div class="bg-orange-300 text-gray-900 px-4 py-1 rounded-t-lg font-mono text-sm">#{title}</div>
          <div class="px-4 bg-gray-300 text-gray-900 rounded-b-lg shadow-md"><pre class="overflow-x-auto"><code class="block font-mono text-sm leading-relaxed">#{escape_html(content.content)}</code></pre></div>
        HTML_BLOCK
      end
    end
  end
end
