# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::ParsedLine do
  let(:parser) { Cosensee::LineParser.new }

  describe '#codeblock?' do
    context 'when line_content is a Codeblock' do
      let(:parsed_line) { parser.parse('code:content') }

      it 'returns true' do
        expect(parsed_line.codeblock?).to be(true)
      end
    end

    context 'when line_content is not a Codeblock' do
      let(:parsed_line) { parser.parse('[aaa] `bbb` ccc') }

      it 'returns false' do
        expect(parsed_line.codeblock?).to be(false)
      end
    end
  end

  describe '#parsed?' do
    let(:parsed_line) { parser.parse('done.') }

    it 'returns the parsed state' do
      expect(parsed_line.parsed?).to be(true)
    end
  end

  describe '#line_content?' do
    context 'when line_content is present' do
      let(:parsed_line) { parser.parse('> foo') }

      it 'returns true' do
        expect(parsed_line.line_content?).to be(true)
      end
    end

    context 'when line_content is nil' do
      let(:parsed_line) { parser.parse('[foo] bar `buz`') }

      it 'returns false' do
        expect(parsed_line.line_content?).to be(false)
      end
    end
  end

  describe '#indent_level' do
    let(:parsed_line) { parser.parse('  [foo] bar `buz`') }

    it 'returns the indent level' do
      expect(parsed_line.indent_level).to eq(2)
    end
  end

  describe '#match' do
    let(:parsed_line) { Cosensee::ParsedLine.new(rest: '> remaining content') }
    let(:pattern) { />/ }

    it 'matches the pattern against rest' do
      expect(parsed_line.match(pattern)).to be_a(MatchData)
      expect(parsed_line.match(pattern)[0]).to eq('>')
    end
  end

  describe '#split_rest_by' do
    let(:delimiter) { '`' }
    let(:parsed_line) { Cosensee::ParsedLine.new(rest: 'aaa`bb`ccc`ddd') }

    it 'splits rest by the given string' do
      expect(parsed_line.split_rest_by(delimiter)).to eq(%w[aaa bb ccc ddd])
    end
  end

  describe '#update' do
    let(:parsed_line) { Cosensee::ParsedLine.new(rest: 'rest', parsed: false) }

    it 'updates the allowed attributes' do
      parsed_line.update(rest: 'new rest', parsed: true)
      expect(parsed_line.rest).to eq('new rest')
      expect(parsed_line.parsed?).to be(true)
    end

    it 'raises an error for invalid attributes' do
      expect { parsed_line.update(invalid_attr: 'value') }.to raise_error(ArgumentError, /Attribute invalid_attr is not allowed to be updated/)
    end
  end

  describe '#raw' do
    context 'when quote' do
      let(:parsed_line) { parser.parse('  > abc `def`') }

      it 'returns the raw representation of indent and line_content' do
        expect(parsed_line.raw).to eq('  > abc `def`')
      end
    end

    context 'when codeblock' do
      let(:parsed_line) { parser.parse('code:foo.txt') }

      it 'returns the raw representation of indent and line_content' do
        expect(parsed_line.raw).to eq('code:foo.txt')
      end
    end

    context 'when not line_content' do
      let(:parsed_line) { parser.parse('   abc [ aaa `def` ccc]') }

      it 'returns the raw representation of indent and content array' do
        expect(parsed_line.raw).to eq('   abc [ aaa `def` ccc]')
      end
    end
  end

  describe '#==' do
    let(:parsed_line) { parser.parse('  abc `def`') }
    let(:other_line) { parser.parse('  abc `def`') }

    context 'when all attributes match' do
      it 'returns true' do
        expect(parsed_line == other_line).to be(true)
      end
    end

    context 'when any attribute does not match(rest)' do
      before { other_line.rest = 'different rest' }

      it 'returns false' do
        expect(parsed_line == other_line).to be(false)
      end
    end

    context 'when any attribute does not match(parsed)' do
      before { other_line.parsed = false }

      it 'returns false' do
        expect(parsed_line == other_line).to be(false)
      end
    end
  end
end
