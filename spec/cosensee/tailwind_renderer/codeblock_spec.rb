# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::TailwindRenderer::Codeblock do
  let(:line_parser) { Cosensee::LineParser.new }
  let(:first_line) { line_parser.parse('  code:test.rb') }
  let(:additional_line) { line_parser.parse('   a = Foo.bar(2); `foo`.buz(a: "hoge")') }
  let(:additional_line2) { line_parser.parse('     # 日本語のコメント') }
  let(:project) { build(:project) }

  describe '#render' do
    let(:merged_lines) { Cosensee::LineParser.merge_blocks([first_line, additional_line, additional_line2]) }

    it 'renders the correct HTML block' do
      codeblock = Cosensee::TailwindRenderer::Codeblock.new(merged_lines.first.line_content, project)
      expected_html = <<~HTML_BLOCK
        <div class="bg-orange-300 text-gray-900 px-4 py-1 rounded-t-lg font-mono text-sm">test.rb</div>
        <div class="px-4 bg-gray-300 text-gray-900 rounded-b-lg shadow-md"><pre class="overflow-x-auto"><code class="block font-mono text-sm leading-relaxed"> a = Foo.bar(2); `foo`.buz(a: &quot;hoge&quot;)
           # 日本語のコメント</code></pre></div>
      HTML_BLOCK

      expect(codeblock.render).to eq(expected_html)
    end
  end
end
