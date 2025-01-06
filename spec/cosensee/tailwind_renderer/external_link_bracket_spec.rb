# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::ExternalLinkBracket do
  describe '#render' do
    context 'when anchor is not nil' do
      it 'convert ExternalLinkBracket to HTML' do
        content = Cosensee::ExternalLinkBracket.new(content: ['https://example.com/link foo'], link: 'https://example.com/link', anchor: 'foo', raw: '[https://example.com/link foo]')
        expect(Cosensee::TailwindRenderer::ExternalLinkBracket.new(content:, project: nil).render).to eq %(<span><a href="https://example.com/link" class="text-blue-500 hover:text-blue-700">foo</a></span>)
      end
    end

    context 'when anchor is nil' do
      it 'convert ExternalLinkBracket to HTML' do
        content = Cosensee::ExternalLinkBracket.new(content: ['https://example.com/link'], link: 'https://example.com/link', anchor: nil, raw: '[https://example.com/link]')
        expect(Cosensee::TailwindRenderer::ExternalLinkBracket.new(content:, project: nil).render).to eq %(<span><a href="https://example.com/link" class="text-blue-500 hover:text-blue-700">https://example.com/link</a></span>)
      end
    end
  end
end
