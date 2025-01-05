# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    ParsedLine = Data.define(:content) do
      include HtmlEncodable

      def render
        result = if content.line_content?
                   TailwindRenderer.new(content: content.line_content).render
                 else
                   content.content.map do |c|
                     if c.is_a?(String)
                       escape_html(c)
                     else
                       TailwindRenderer.new(content: c).render
                     end
                   end.join
                 end
        level = content.indent_level * 2
        result = '&nbsp;' if result == ''
        if level > 0
          %(<div class="relative pl-[#{level}rem]"><span class="absolute left-[#{level - 1}rem] top-1/2 -translate-y-1/2 w-1.5 h-1.5 rounded-full bg-gray-800"></span>#{result}</div>)
        else
          %(<div class="relative pl-[#{level}rem]">#{result}</div>)
        end
      end
    end
  end
end
