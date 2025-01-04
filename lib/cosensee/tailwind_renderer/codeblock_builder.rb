# frozen_string_literal: true

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
        # rubocop:disable Style/StringConcatenation
        %(<div class="mx-auto mt-4">) +
          %(<div class="bg-orange-300 text-gray-900 px-4 py-1 rounded-t-lg font-mono text-sm">#{first_line.content}</div>) +
          %(<div class="px-4 bg-gray-300 text-gray-900 rounded-b-lg shadow-md"><pre class="overflow-x-auto"><code class="block font-mono text-sm leading-relaxed">) +
          lines.map { |line| ParsedLine.render(line) }.join +
          %(</code></pre></div>) +
          %(</div>)
        # rubocop:enable Style/StringConcatenation
      end
    end
  end
end
