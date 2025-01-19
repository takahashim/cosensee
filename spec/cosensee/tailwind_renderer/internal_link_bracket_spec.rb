# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::InternalLinkBracket do
  describe '#render' do
    it 'convert InternalLinkBracket to HTML' do
      content = Cosensee::Node::InternalLinkBracket.new(content: ['abc'],  anchor: 'abc', raw: '[abc]')
      expect(Cosensee::TailwindRenderer::InternalLinkBracket.new(content:, project: nil).render).to eq %(<span><a href="abc.html" class="text-blue-500 hover:text-blue-700">abc</a></span>)
    end
  end
end
