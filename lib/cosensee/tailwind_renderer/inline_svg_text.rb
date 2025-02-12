# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    # extended renderer for inline SVG text
    InlineSvgText = Data.define(:content, :project) do
      include HtmlEncodable

      def render
        svg_lines = content.content.lines.map do |line|
          %(<tspan x="0" dy="1.4em">#{svg_line(line)}</tspan>\n)
        end

        <<~SVG_ELEMENT
          <svg style="inherit" xmlns="http://www.w3.org/2000/svg" class="svg-text">
            <style>
              .text { -ms-user-select: none; -webkit-user-select: none; user-select: none; }
              @media print { .svg-text { display: none !important; } text  { display: none !important; } }
            </style>
            <text x="0" y="0" font-size="inherit" class="text" fill="break">
            #{svg_lines.join}
            </text>
          </svg>
        SVG_ELEMENT
      end

      private

      def svg_line(line)
        if line.strip.empty?
          '&#xA0;'
        else
          escape_html(line.chomp)
        end
      end
    end
  end
end
