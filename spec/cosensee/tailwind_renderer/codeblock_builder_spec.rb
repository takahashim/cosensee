# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::TailwindRenderer::CodeblockBuilder do
  let(:line_parser) { Cosensee::LineParser.new }
  let(:first_line) { line_parser.parse('  code:test.rb') }
  let(:additional_line) { line_parser.parse('  a = Foo.bar(2); `foo`.buz(a: "hoge")') }
  let(:additional_line2) { line_parser.parse('     # 日本語のコメント') }
  let(:another_line) { line_parser.parse(' "other block line!"') }

  describe '#initialize' do
    it 'initializes with the correct first_line and base_indent_level' do
      builder = Cosensee::TailwindRenderer::CodeblockBuilder.new(first_line)
      expect(builder.first_line).to eq(first_line)
      expect(builder.base_indent_level).to eq(2)
      expect(builder.lines).to be_empty
    end
  end

  describe '#append' do
    it 'appends a parsed line to the lines array' do
      builder = Cosensee::TailwindRenderer::CodeblockBuilder.new(first_line)
      builder.append(additional_line)
      expect(builder.lines).to include(additional_line)
    end
  end

  describe '#continued_line?' do
    it 'returns true for a line with indent_level >= base_indent_level' do
      builder = Cosensee::TailwindRenderer::CodeblockBuilder.new(first_line)
      expect(builder.continued_line?(additional_line)).to be true
    end

    it 'returns false for a line with indent_level < base_indent_level' do
      builder = Cosensee::TailwindRenderer::CodeblockBuilder.new(additional_line)
      expect(builder.continued_line?(another_line)).to be false
    end
  end

  describe '#render' do
    it 'renders the correct HTML block' do
      builder = Cosensee::TailwindRenderer::CodeblockBuilder.new(first_line)
      builder.append(additional_line)
      builder.append(additional_line2)
      expected_html = <<~HTML_BLOCK
        <div class="relative pl-[4rem]">
          <div class="bg-orange-300 text-gray-900 px-4 py-1 rounded-t-lg font-mono text-sm">test.rb</div>
          <div class="px-4 bg-gray-300 text-gray-900 rounded-b-lg shadow-md"><pre class="overflow-x-auto"><code class="block font-mono text-sm leading-relaxed">  a = Foo.bar(2); `foo`.buz(a: &quot;hoge&quot;)
             # 日本語のコメント</code></pre></div>
        </div>
      HTML_BLOCK

      expect(builder.render).to eq(expected_html)
    end
  end
end
