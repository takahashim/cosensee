# frozen_string_literal: true

module Cosensee
  # provide `renderer_class` method
  module RenderClassFindable
    # ex. Cosensee::TailwindRenderer::Code for Cosensee::Node::Code
    def find_renderer_class(content)
      name = content.class.name.split('::').last

      Cosensee::TailwindRenderer.const_get(name)
    end
  end
end
