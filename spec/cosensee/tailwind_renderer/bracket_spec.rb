# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::Bracket do
  describe '#render' do

    it 'convert Bracket to HTML' do
      bracket = Cosensee::Bracket.new(['abc'])
      expect(Cosensee::TailwindRenderer.new(content: bracket).render).to eq '<code class="bg-gray-100 text-red-500 px-1 py-0.5 rounded">foo bar</code>'
    end
  end
end
