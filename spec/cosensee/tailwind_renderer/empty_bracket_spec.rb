# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::TailwindRenderer::EmptyBracket do
  describe '#render' do
    it 'convert EmptyBracket to HTML' do
      content = Cosensee::EmptyBracket.new(content: [''], raw: '[]')
      expect(Cosensee::TailwindRenderer::EmptyBracket.new(content:, project: nil).render).to eq %(<span>[]</span>)
    end
  end
end
