# frozen_string_literal: true

RSpec.describe Cosensee::LineParser do
  let(:parser) { Cosensee::LineParser.new }

  describe '#parse_indent' do
    it 'parse indent segments' do
      expect(parser.parse_indent('')).to eq [Cosensee::Indent.new(''), '']
      expect(parser.parse_indent(' ')).to eq [Cosensee::Indent.new(' '), '']
      expect(parser.parse_indent(' a')).to eq [Cosensee::Indent.new(' '), 'a']
      expect(parser.parse_indent(" \t")).to eq [Cosensee::Indent.new(" \t"), '']
      expect(parser.parse_indent(" \ta")).to eq [Cosensee::Indent.new(" \t"), 'a']
      expect(parser.parse_indent(" b\ta")).to eq [Cosensee::Indent.new(' '), "b\ta"]
    end
  end

  describe '#parse_whole_line' do
    it 'parse command line' do
      expect(parser.parse_whole_line('')).to eq ['', '']
      expect(parser.parse_whole_line('a$')).to eq ['', 'a$']
      expect(parser.parse_whole_line('$ ')).to eq ['', '$ ']
      expect(parser.parse_whole_line('$ a')).to eq [Cosensee::CommandLine.new('$'), 'a']
      expect(parser.parse_whole_line('% ab')).to eq [Cosensee::CommandLine.new('%'), 'ab']
      expect(parser.parse_whole_line('%% a')).to eq ['', '%% a']
      expect(parser.parse_whole_line('% a $ b')).to eq [Cosensee::CommandLine.new('%'), 'a $ b']
    end

    it 'parse quote segments' do
      expect(parser.parse_whole_line('')).to eq ['', '']
      expect(parser.parse_whole_line('a>')).to eq ['', 'a>']
      expect(parser.parse_whole_line('>')).to eq [Cosensee::Quote.new('>'), '']
      expect(parser.parse_whole_line('>ab')).to eq [Cosensee::Quote.new('>'), 'ab']
      expect(parser.parse_whole_line('>>b')).to eq [Cosensee::Quote.new('>'), '>b']
    end

    it 'parse codeblock segments' do
      expect(parser.parse_whole_line('')).to eq ['', '']
      expect(parser.parse_whole_line('code:')).to eq ['', 'code:']
      expect(parser.parse_whole_line('code:abc')).to eq ['abc', '']
      expect(parser.parse_whole_line('code:abc def')).to eq ['abc def', '']
      expect(parser.parse_whole_line('code:abc[] `de`f')).to eq ['abc[] `de`f', '']
    end
  end

  describe '#parse_code' do
    it 'parse code segments' do
      expect(parser.parse_code('')).to eq []
      expect(parser.parse_code('`')).to eq ['`']
      expect(parser.parse_code('``')).to eq ['', Cosensee::Code.new(''), '']
      expect(parser.parse_code('a`b`')).to eq ['a', Cosensee::Code.new('b'), '']
      expect(parser.parse_code('a`b`c')).to eq ['a', Cosensee::Code.new('b'), 'c']
      expect(parser.parse_code('a`b`c`d')).to eq ['a', Cosensee::Code.new('b'), 'c`d']
      expect(parser.parse_code('a`b`c`d`')).to eq ['a', Cosensee::Code.new('b'), 'c', Cosensee::Code.new('d'), '']
    end
  end

  describe '#parse_bracket' do
    it 'parse bracket segments' do
      expect(parser.parse_bracket([''])).to eq []
      expect(parser.parse_bracket(['['])).to eq ['[']
      expect(parser.parse_bracket(['[]'])).to eq [Cosensee::Bracket.new([''])]
      expect(parser.parse_bracket(['[abc]'])).to eq [Cosensee::Bracket.new(['abc'])]
      expect(parser.parse_bracket(['12[abc]34'])).to eq ['12', Cosensee::Bracket.new(['abc']), '34']
      expect(parser.parse_bracket(['[abc]12[xyz]'])).to eq [Cosensee::Bracket.new(['abc']), '12', Cosensee::Bracket.new(['xyz'])]
      expect(parser.parse_bracket(['[abc]12[xyz'])).to eq [Cosensee::Bracket.new(['abc']), '12[xyz']
      expect(parser.parse_bracket(['[a', Cosensee::Code.new('b'), 'c]'])).to eq [Cosensee::Bracket.new(['a', Cosensee::Code.new('b'), 'c'])]
      expect(parser.parse_bracket(['[a', Cosensee::Code.new('b'), 'c'])).to eq ['[a', Cosensee::Code.new('b'), 'c']
      expect(parser.parse_bracket(['x[a', Cosensee::Code.new('b'), 'c', 'd]e'])).to eq ['x', Cosensee::Bracket.new(['a', Cosensee::Code.new('b'), 'c', 'd']), 'e']
    end
  end

  describe '#parse' do
    it 'parse whole line' do
      expect(parser.parse('')).to eq [Cosensee::Indent.new(''), '', []]
      expect(parser.parse(' ')).to eq [Cosensee::Indent.new(' '), '', []]
      expect(parser.parse('a')).to eq [Cosensee::Indent.new(''), '', ['a']]
      expect(parser.parse(' a')).to eq [Cosensee::Indent.new(' '), '', ['a']]
      expect(parser.parse(" \tabc")).to eq [Cosensee::Indent.new(" \t"), '', ['abc']]
      expect(parser.parse(' `a`bc')).to eq [Cosensee::Indent.new(' '), '', [Cosensee::Code.new('a'), 'bc']]
      expect(parser.parse('a`b`c')).to eq [Cosensee::Indent.new(''), '', ['a', Cosensee::Code.new('b'), 'c']]
      expect(parser.parse('> a`b`c')).to eq [Cosensee::Indent.new(''), Cosensee::Quote.new('>'), [' a', Cosensee::Code.new('b'), 'c']]
      expect(parser.parse('code:')).to eq [Cosensee::Indent.new(''), '', ['code:']]
      expect(parser.parse('code:a`b`c')).to eq [Cosensee::Indent.new(''), Cosensee::Codeblock.new('a`b`c'), []]
      expect(parser.parse('$ a b c')).to eq [Cosensee::Indent.new(''), Cosensee::CommandLine.new('$'), ['a b c']]
      expect(parser.parse('$ a `b` c')).to eq [Cosensee::Indent.new(''), Cosensee::CommandLine.new('$'), ['a ', Cosensee::Code.new('b'), ' c']]
      expect(parser.parse('[')).to eq [Cosensee::Indent.new(''), '', ['[']]
      expect(parser.parse('[]')).to eq [Cosensee::Indent.new(''), '', [Cosensee::Bracket.new([''])]]
      expect(parser.parse('[abc]')).to eq [Cosensee::Indent.new(''), '', [Cosensee::Bracket.new(['abc'])]]
      expect(parser.parse('12[abc]34')).to eq [Cosensee::Indent.new(''), '', ['12', Cosensee::Bracket.new(['abc']), '34']]
      expect(parser.parse('12[a`bc]34')).to eq [Cosensee::Indent.new(''), '', ['12', Cosensee::Bracket.new(['a`bc']), '34']]
      expect(parser.parse('12[a`b`c]34')).to eq [Cosensee::Indent.new(''), '', ['12', Cosensee::Bracket.new(['a', Cosensee::Code.new('b'), 'c']), '34']]
    end
  end
end
