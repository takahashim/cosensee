# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::InternalLinkBracket do
  describe '#render' do
    it 'convert InternalLinkBracket to HTML' do
      content = Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc', raw: '[abc]')
      expect(Cosensee::TailwindRenderer::InternalLinkBracket.new(content:).render).to eq %(<span><a href="abc.html" class="text-blue-500 hover:text-blue-700">abc</a></span>)
    end
  end
end
