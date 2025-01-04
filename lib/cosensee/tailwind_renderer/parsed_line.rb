# frozen_string_literal: true

require 'cgi/util'

module Cosensee
  class TailwindRenderer
    ParsedLine = Data.define(:content) do
      def render
        if content.line_content?
          TailwindRenderer.new(content: content.line_content).render
        else
          content.each do |c|
            TailwindRenderer.new(content: c).render
          end
        end
      end
    end
  end
end
