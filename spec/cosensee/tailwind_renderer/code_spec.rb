# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::TailwindRenderer::Code do
  describe '#render' do
    it 'convert Code to HTML' do
      content = Cosensee::Node::Code.new(content: 'abc', raw: '`abc`')
      expect(Cosensee::TailwindRenderer::Code.new(content:, project: nil).render).to eq %(<code class="bg-gray-100 text-red-500 px-1 py-0.5 rounded">abc</code>)
    end
  end
end
