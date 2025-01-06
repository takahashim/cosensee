# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::Link do
  describe '#render' do
    it 'convert Link to HTML' do
      content = Cosensee::Node::Link.new(content: 'https://example.com', raw: 'https://example.com')
      expect(Cosensee::TailwindRenderer::Link.new(content:, project: nil).render).to eq %(<span><a href="https://example.com" class="text-blue-500 hover:text-blue-700">https://example.com</a></span>)
    end
  end
end
