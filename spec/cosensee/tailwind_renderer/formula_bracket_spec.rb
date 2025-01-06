# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::FormulaBracket do
  describe '#render' do
    it 'convert FormulaBracket to HTML' do
      content = Cosensee::FormulaBracket.new(content: ['$ a < b < c'], formula: 'a < b < c', raw: '$ a < b < c')
      expect(Cosensee::TailwindRenderer::FormulaBracket.new(content:, project: nil).render).to eq %(<span class="math-container">$a &lt; b &lt; c$</span>)
    end
  end
end
