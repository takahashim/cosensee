# frozen_string_literal: true

require 'cgi/util'

module Cosensee
  class TailwindRenderer
    # connect parsed lines to a code block
    class CodeblockBuilder
      def initialize(parsed_line)
        @first_line = parsed_line
        @base_indent_level = parsed_line.indent_level
        @lines = []
      end

      attr_reader :first_line, :lines, :base_indent_level

      def append(parsed_line)
        @lines << parsed_line
      end

      def continued_line?(parsed_line)
        parsed_line.indent_level >= base_indent_level
      end

      def render
        indent_level = base_indent_level * 2
        title = first_line.line_content.content
        <<~HTML_BLOCK
          <div class="relative pl-[#{indent_level}rem]">
            <div class="bg-orange-300 text-gray-900 px-4 py-1 rounded-t-lg font-mono text-sm">#{title}</div>
            <div class="px-4 bg-gray-300 text-gray-900 rounded-b-lg shadow-md"><pre class="overflow-x-auto"><code class="block font-mono text-sm leading-relaxed">#{CGI.escape_html(lines.map(&:raw).join("\n"))}</code></pre></div>
          </div>
        HTML_BLOCK
      end
    end
  end
end
