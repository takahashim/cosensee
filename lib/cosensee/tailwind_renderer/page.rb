# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    Page = Data.define(:content, :project) do
      def render
        page = content
        rendered_lines = page.parsed_lines.map do |parsed_line|
          ParsedLine.new(parsed_line, project).render
        end

        rendered_lines.join
      end
    end
  end
end
