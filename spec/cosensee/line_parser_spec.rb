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
      expect(parser.parse_whole_line('$ a')).to eq [Cosensee::CommandLine.new(content: 'a', prompt: '$'), '']
      expect(parser.parse_whole_line('% ab')).to eq [Cosensee::CommandLine.new(content: 'ab', prompt: '%'), '']
      expect(parser.parse_whole_line('%% a')).to eq ['', '%% a']
      expect(parser.parse_whole_line('% a $ b')).to eq [Cosensee::CommandLine.new(content: 'a $ b', prompt: '%'), '']
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
      expect(parser.parse_whole_line('code:abc')).to eq [Cosensee::Codeblock.new('abc'), '']
      expect(parser.parse_whole_line('code:abc def')).to eq [Cosensee::Codeblock.new('abc def'), '']
      expect(parser.parse_whole_line('code:abc[] `de`f')).to eq [Cosensee::Codeblock.new('abc[] `de`f'), '']
    end
  end

  describe '#parse_hastag' do
    it 'parse hashtag segments' do
      expect(parser.parse_hashtag([''])).to eq ['']
      expect(parser.parse_hashtag(['#'])).to eq ['#']
      expect(parser.parse_hashtag(['#a'])).to eq ['', Cosensee::HashTag.new('a'), '']
      expect(parser.parse_hashtag([' #a!#b'])).to eq [' ', Cosensee::HashTag.new('a!#b'), '']
      expect(parser.parse_hashtag([' #abc '])).to eq [' ', Cosensee::HashTag.new('abc'), ' ']
      expect(parser.parse_hashtag([' #あいうえお '])).to eq [' ', Cosensee::HashTag.new('あいうえお'), ' ']
      expect(parser.parse_hashtag(['#a #b #c'])).to eq ['', Cosensee::HashTag.new('a'), ' ', Cosensee::HashTag.new('b'), ' ', Cosensee::HashTag.new('c'), '']
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

  describe '#parse_double_bracket' do
    it 'parse double bracket segments' do
      expect(parser.parse_double_bracket([''])).to eq []
      expect(parser.parse_double_bracket(['['])).to eq ['[']
      expect(parser.parse_double_bracket(['[]'])).to eq ['[]']
      expect(parser.parse_double_bracket(['[[]]'])).to eq ['[[]]']
      expect(parser.parse_double_bracket(['[[a]]'])).to eq [Cosensee::DoubleBracket.new('a')]
      expect(parser.parse_double_bracket(['[[a[b]c]]'])).to eq [Cosensee::DoubleBracket.new('a[b]c')]
      expect(parser.parse_double_bracket(['[[a[[[[a[[]aa` ]]'])).to eq [Cosensee::DoubleBracket.new('a[[[[a[[]aa` ')]
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
      expect(parser.parse('')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: []
      )
      expect(parser.parse(' ')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(' '),
        line_content: '',
        content: []
      )
      expect(parser.parse('a')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: ['a']
      )
      expect(parser.parse(' a')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(' '),
        line_content: '',
        content: ['a']
      )
      expect(parser.parse(" \tabc")).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(" \t"),
        line_content: '',
        content: ['abc']
      )
      expect(parser.parse(' `a`bc')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(' '),
        line_content: '',
        content: [Cosensee::Code.new('a'), 'bc']
      )
      expect(parser.parse('a`b`c')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: ['a', Cosensee::Code.new('b'), 'c']
      )
      expect(parser.parse('> a`b`c')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: Cosensee::Quote.new('>'),
        content: [' a', Cosensee::Code.new('b'), 'c']
      )
      expect(parser.parse('code:')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: ['code:']
      )
      expect(parser.parse('code:a`b`c')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: Cosensee::Codeblock.new('a`b`c'),
        content: []
      )
      expect(parser.parse('$ a b c')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: Cosensee::CommandLine.new(content: 'a b c', prompt: '$'),
        content: []
      )
      expect(parser.parse('$ a [b] c')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: Cosensee::CommandLine.new(content: 'a [b] c', prompt: '$'),
        content: []
      )
      expect(parser.parse('$ a `b` c')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: Cosensee::CommandLine.new(content: 'a `b` c', prompt: '$'),
        content: []
      )
      expect(parser.parse('[')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: ['[']
      )
      expect(parser.parse('[]')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: [Cosensee::Bracket.new([''])]
      )
      expect(parser.parse('[abc]')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: [Cosensee::Bracket.new(['abc'])]
      )
      expect(parser.parse('12[abc]34')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: ['12', Cosensee::Bracket.new(['abc']), '34']
      )
      expect(parser.parse('a[[b[]c]]d[e]f')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: ['a', Cosensee::DoubleBracket.new('b[]c'), 'd', Cosensee::Bracket.new(['e']), 'f']
      )
      expect(parser.parse('12 #abc 34')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: ['12 ', Cosensee::HashTag.new('abc'), ' 34']
      )
      expect(parser.parse('12[a`bc]34')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: ['12', Cosensee::Bracket.new(['a`bc']), '34']
      )
      expect(parser.parse('12[a`bc]34')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new(''),
        line_content: '',
        content: ['12', Cosensee::Bracket.new(['a`bc']), '34']
      )
      expect(parser.parse('   12[a`b`c]34')).to eq Cosensee::ParsedLine.new(
        indent: Cosensee::Indent.new('   '),
        line_content: '',
        content: ['12', Cosensee::Bracket.new(['a', Cosensee::Code.new('b'), 'c']), '34']
      )
    end
  end
end
