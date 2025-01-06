# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::ImageBracket do
  describe '#render' do
    context 'when link is nil' do
      it 'convert ImageBracket to HTML' do
        content = Cosensee::Node::ImageBracket.new(
          content: ['https://example.com/example.jpg'],
          link: nil,
          src: 'https://example.com/example.jpg',
          raw: '[https://example.com/example.jpg]'
        )
        expect(Cosensee::TailwindRenderer::ImageBracket.new(content:, project: nil).render).to eq %(<span><img src="https://example.com/example.jpg" class="max-w-max max-h-80"></span>)
      end
    end

    context 'when link is not nil' do
      it 'convert ImageBracket to HTML' do
        content = Cosensee::Node::ImageBracket.new(
          content: ['https://example.com/example.jpg http://example.com/link'],
          link: 'http://example.com/link',
          src: 'https://example.com/example.jpg',
          raw: '[https://example.com/example.jpg http://example.com/link]'
        )
        expect(Cosensee::TailwindRenderer::ImageBracket.new(content:, project: nil).render).to eq %(<span><a href="http://example.com/link"><img src="https://example.com/example.jpg" class="max-w-max max-h-80"></a></span>)
      end
    end
  end
end
