# frozen_string_literal: true

module Cosensee
  # convert into html
  class TailwindRenderer
    def initialize(content:)
      @content = content
    end

    attr_reader :content

    def render
      renderer_class(content).new(content).render
    end

    def renderer_class(content)
      name = content.class.name.split('::').last

      Cosensee::TailwindRenderer.const_get(name)
    end
  end
end
