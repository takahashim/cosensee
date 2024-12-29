# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::Bracket do
  describe '#render' do
    it 'convert Bracket to HTML' do
      bracket = Cosensee::Bracket.new(['abc'])
      expect(Cosensee::TailwindRenderer.new(content: bracket).render).to eq "<span><a href='abc'>abc</a></span>"
    end
  end
end
