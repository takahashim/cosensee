# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    Page = Data.define(:content) do
      def render
        current_block_builder = nil

        page = content
        rendered_lines = []

        page.parsed_lines.each do |parsed_line|
          if current_block_builder
            if current_block_builder.continued_line?(parsed_line)
              current_block_builder.append(parsed_line)
            else
              rendered_lines << current_block_builder.render
              rendered_lines << ParsedLine.new(parsed_line).render
            end
          elsif parsed_line.coce_block?
            current_block_builder = CodeBlockBuilder.new(parsed_line)
          else
            rendered_lines << ParsedLine.new(parsed_line).render
          end
        end

        rendered_lines.join
      end
    end
  end
end
