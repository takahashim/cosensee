# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::ImageBracket do
  describe '#render' do
    context 'when link is nil' do
      it 'convert ImageBracket to HTML' do
        content = Cosensee::ImageBracket.new(
          content: ['https://example.com/example.jpg'],
          link: nil,
          src: 'https://example.com/example.jpg',
          raw: '[https://example.com/example.jpg]'
        )
        expect(Cosensee::TailwindRenderer::ImageBracket.new(content:).render).to eq %(<span><img src="https://example.com/example.jpg"></span>)
      end
    end

    context 'when link is not nil' do
      it 'convert ImageBracket to HTML' do
        content = Cosensee::ImageBracket.new(
          content: ['https://example.com/example.jpg http://example.com/link'],
          link: 'http://example.com/link',
          src: 'https://example.com/example.jpg',
          raw: '[https://example.com/example.jpg http://example.com/link]'
        )
        expect(Cosensee::TailwindRenderer::ImageBracket.new(content:).render).to eq %(<span><a href="http://example.com/link"><img src="https://example.com/example.jpg"></a></span>)
      end
    end
  end
end
