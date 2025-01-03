# frozen_string_literal: true

require 'rspec'

RSpec.describe Cosensee::TailwindRenderer::DecorateBracket do
  subject(:renderer) { Cosensee::TailwindRenderer::DecorateBracket.new(bracket) }

  let(:font_size) { nil }
  let(:underlined) { nil }
  let(:slanted) { nil }
  let(:deleted) { nil }
  let(:bracket) { Cosensee::DecorateBracket.new(content: [], font_size:, underlined:, slanted:, deleted:, text: 'Sample Text') }

  describe '#render' do
    context 'when no styles are applied' do
      it 'returns the text wrapped in a span with no class' do
        expect(renderer.render).to eq('<span class="">Sample Text</span>')
      end
    end

    context 'when font_size is applied' do
      let(:font_size) { 2 }

      it 'applies the correct font size class' do
        expect(renderer.render).to eq('<span class="text-xl">Sample Text</span>')
      end
    end

    context 'when underlined is applied' do
      let(:underlined) { true }

      it 'applies the underline class' do
        expect(renderer.render).to eq('<span class="underline">Sample Text</span>')
      end
    end

    context 'when slanted is applied' do
      let(:slanted) { true }

      it 'applies the italic class' do
        expect(renderer.render).to eq('<span class="italic">Sample Text</span>')
      end
    end

    context 'when deleted is applied' do
      let(:deleted) { true }

      it 'applies the line-through class' do
        expect(renderer.render).to eq('<span class="line-through">Sample Text</span>')
      end
    end

    context 'when multiple styles are applied' do
      let(:font_size) { 3 }
      let(:underlined) { true }
      let(:slanted) { true }
      let(:deleted) { true }

      it 'applies all relevant classes' do
        expect(renderer.render).to eq('<span class="text-2xl underline italic line-through">Sample Text</span>')
      end
    end
  end
end
