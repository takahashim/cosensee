# frozen_string_literal: true

module Cosensee
  # convert into html
  class TailwindRenderer
    def initialize(content:)
      @content = content
    end

    attr_reader :content

    def render
      if content.is_a?(Array)
        content.map do |c|
          if c.is_a?(String)
            CGI.escape_html(c)
          else
            renderer_class(c).new(content: c).render
          end
        end.join
      else
        renderer_class(content).new(content:).render
      end
    end

    def renderer_class(content)
      name = content.class.name.split('::').last

      Cosensee::TailwindRenderer.const_get(name)
    end
  end
end
