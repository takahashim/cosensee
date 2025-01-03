# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::FormulaBracket do
  describe '#render' do
    it 'convert FormulaBracket to HTML' do
      content = Cosensee::FormulaBracket.new(content: ['$ a < b < c'], formula: 'a < b < c')
      expect(Cosensee::TailwindRenderer::FormulaBracket.new(content:).render).to eq %(<span class="math-container">$a &lt; b &lt; c$</span>)
    end
  end
end
