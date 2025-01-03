# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::IconBracket do
  describe '#render' do
    it 'convert IconBracket to HTML' do
      content = Cosensee::IconBracket.new(content: ['foobar.icon'], icon_name: 'foobar')
      expect(Cosensee::TailwindRenderer::IconBracket.new(content:).render).to eq %(<span>[icon:foobar]</span>)
    end
  end
end
