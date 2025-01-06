# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::TailwindRenderer::BlankBracket do
  let(:content) { Cosensee::Node::BlankBracket.new(content: ['  '], blank: '  ', raw: '  ') }
  let(:bracket) { Cosensee::TailwindRenderer::BlankBracket.new(content:, project: nil) }

  describe '#render' do
    it 'renders an empty bracket with no content' do
      expect(bracket.render).to eq('<span>  </span>')
    end
  end
end
