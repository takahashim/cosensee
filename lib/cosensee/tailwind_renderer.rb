# frozen_string_literal: true

module Cosensee
  # convert into html
  class TailwindRenderer
    include HtmlEncodable

    # content is Cosensee objects or an array of them
    def initialize(content:, project:)
      @content = content
      @project = project
    end

    attr_reader :content, :project

    def render
      if content.is_a?(Array)
        content.map do |c|
          if c.is_a?(String)
            escape_html(c)
          else
            renderer_class(c).new(content: c, project:).render
          end
        end.join
      else
        renderer_class(content).new(content:, project:).render
      end
    end

    # ex. Cosensee::TailwindRenderer::Code for Cosensee::Code
    def renderer_class(content)
      name = content.class.name.split('::').last

      Cosensee::TailwindRenderer.const_get(name)
    end
  end
end
