# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    DecorateBracket = Data.define(:content) do
      def render
        classes = []
        classes << font_sizes[content.font_size] if content.font_size
        classes << 'font-semibold' if content.font_size && content.font_size > 0
        classes << 'underline' if content.underlined
        classes << 'italic' if content.slanted
        classes << 'line-through' if content.deleted
        class_attr = classes.join(' ')

        %(<span class="#{class_attr}">#{content.text}</span>)
      end

      private

      def font_sizes
        %w[text-base text-lg text-xl text-2xl text-3xl text-4xl text-5xl text-6xl text-7xl text-8xl text-9xl].freeze
      end
    end
  end
end
