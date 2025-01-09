# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::TailwindRenderer::Quote do
  let(:project) { instance_double(Cosensee::Project) }

  describe '#render' do
    it 'convert Quote to HTML' do
      source = '> a`b`c'
      content = Cosensee::LineParser.parse(source)

      expect(Cosensee::TailwindRenderer.new(content:, project:).render).to eq %(<div class="relative pl-[0rem]"><blockquote class="border-l-4 border-gray-300 bg-gray-100 px-4 text-gray-800"> a<code class="bg-gray-100 text-red-500 px-1 py-0.5 rounded">b</code>c</blockquote></div>)
    end
  end
end
