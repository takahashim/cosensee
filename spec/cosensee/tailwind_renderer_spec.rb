# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer do
  let(:code) { Cosensee::Code.new('foo bar', '`foo bar`') }

  describe '#render' do
    it 'convert Code to HTML' do
      expect(Cosensee::TailwindRenderer.new(content: code).render).to eq '<code class="bg-gray-100 text-red-500 px-1 py-0.5 rounded">foo bar</code>'
    end
  end
end
