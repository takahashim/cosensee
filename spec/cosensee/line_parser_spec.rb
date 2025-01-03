# frozen_string_literal: true

RSpec.describe Cosensee::LineParser do
  let(:parser) { Cosensee::LineParser.new }

  describe '#parse_indent' do
    it 'parse indent segments' do
      expect(parser.parse_indent('')).to eq [Cosensee::Indent.new, '']
      expect(parser.parse_indent(' ')).to eq [Cosensee::Indent.new(' '), '']
      expect(parser.parse_indent(' a')).to eq [Cosensee::Indent.new(' '), 'a']
      expect(parser.parse_indent(" \t")).to eq [Cosensee::Indent.new(" \t"), '']
      expect(parser.parse_indent(" \ta")).to eq [Cosensee::Indent.new(" \t"), 'a']
      expect(parser.parse_indent(" b\ta")).to eq [Cosensee::Indent.new(' '), "b\ta"]
    end
  end

  describe '#parse_whole_line' do
    it 'parse command line' do
      expect(parser.parse_whole_line('')).to eq [nil, '']
      expect(parser.parse_whole_line('a$')).to eq [nil, 'a$']
      expect(parser.parse_whole_line('$ ')).to eq [nil, '$ ']
      expect(parser.parse_whole_line('$ a')).to eq [Cosensee::CommandLine.new(content: 'a', prompt: '$'), nil]
      expect(parser.parse_whole_line('% ab')).to eq [Cosensee::CommandLine.new(content: 'ab', prompt: '%'), nil]
      expect(parser.parse_whole_line('%% a')).to eq [nil, '%% a']
      expect(parser.parse_whole_line('% a $ b')).to eq [Cosensee::CommandLine.new(content: 'a $ b', prompt: '%'), nil]
    end

    it 'parse quote segments' do
      expect(parser.parse_whole_line('')).to eq [nil, '']
      expect(parser.parse_whole_line('a>')).to eq [nil, 'a>']
      expect(parser.parse_whole_line('>')).to eq [Cosensee::Quote.new('>'), '']
      expect(parser.parse_whole_line('>ab')).to eq [Cosensee::Quote.new('>'), 'ab']
      expect(parser.parse_whole_line('>>b')).to eq [Cosensee::Quote.new('>'), '>b']
    end

    it 'parse codeblock segments' do
      expect(parser.parse_whole_line('')).to eq [nil, '']
      expect(parser.parse_whole_line('code:')).to eq [nil, 'code:']
      expect(parser.parse_whole_line('code:abc')).to eq [Cosensee::Codeblock.new('abc'), nil]
      expect(parser.parse_whole_line('code:abc def')).to eq [Cosensee::Codeblock.new('abc def'), nil]
      expect(parser.parse_whole_line('code:abc[] `de`f')).to eq [Cosensee::Codeblock.new('abc[] `de`f'), nil]
    end
  end

  describe '#parse_hastag' do
    it 'parse hashtag segments' do
      expect(parser.parse_hashtag([''])).to eq []
      expect(parser.parse_hashtag(['#'])).to eq ['#']
      expect(parser.parse_hashtag(['#a'])).to eq [Cosensee::HashTag.new('a')]
      expect(parser.parse_hashtag([' #a!#b'])).to eq [' ', Cosensee::HashTag.new('a!#b')]
      expect(parser.parse_hashtag([' #abc '])).to eq [' ', Cosensee::HashTag.new('abc'), ' ']
      expect(parser.parse_hashtag([' #あいうえお '])).to eq [' ', Cosensee::HashTag.new('あいうえお'), ' ']
      expect(parser.parse_hashtag(['#a #b #c'])).to eq [Cosensee::HashTag.new('a'), ' ', Cosensee::HashTag.new('b'), ' ', Cosensee::HashTag.new('c')]
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

  describe '#parse_url' do
    it 'parse code segments' do
      expect(parser.parse_url([''])).to eq []
      expect(parser.parse_url(['https://'])).to eq ['https://']
      expect(parser.parse_url(['https://example.com'])).to eq [Cosensee::Link.new('https://example.com')]
      expect(parser.parse_url(['https://example.com  '])).to eq [Cosensee::Link.new('https://example.com'), '  ']
      expect(parser.parse_url([' https://example.com '])).to eq [' ', Cosensee::Link.new('https://example.com'), ' ']
      expect(parser.parse_url([' https://example.com/あいうえお '])).to eq [' ', Cosensee::Link.new('https://example.com/あいうえお'), ' ']
      expect(parser.parse_url(['https://example.com https://example.org'])).to eq [Cosensee::Link.new('https://example.com'), ' ', Cosensee::Link.new('https://example.org')]
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
      expect(parser.parse_bracket(['[]'])).to eq [Cosensee::EmptyBracket.new([''])]
      expect(parser.parse_bracket(['[abc]'])).to eq [Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc')]
      expect(parser.parse_bracket(['12[abc]34'])).to eq ['12', Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc'), '34']
      expect(parser.parse_bracket(['[abc]12[xyz]'])).to eq [
        Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc'),
        '12',
        Cosensee::InternalLinkBracket.new(content: ['xyz'], link: 'xyz.html', anchor: 'xyz')
      ]
      expect(parser.parse_bracket(['[abc]12[xyz'])).to eq [Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc'), '12[xyz']
      expect(parser.parse_bracket(['[a', Cosensee::Code.new('b'), 'c]'])).to eq [Cosensee::TextBracket.new(['a', Cosensee::Code.new('b'), 'c'])]
      expect(parser.parse_bracket(['[a', Cosensee::Code.new('b'), 'c'])).to eq ['[a', Cosensee::Code.new('b'), 'c']
      expect(parser.parse_bracket(['x[a', Cosensee::Code.new('b'), 'c', 'd]e'])).to eq ['x', Cosensee::TextBracket.new(['a', Cosensee::Code.new('b'), 'cd']), 'e']
    end
  end

  describe '#parse' do
    where(:source, :parsed) do
      [
        [
          '',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: nil,
            content: []
          )
        ],
        [
          ' ',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new(' '),
            content: []
          )
        ],
        [
          'a',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['a']
          )
        ],
        [
          ' a',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new(' '),
            content: ['a']
          )
        ],
        [
          " \tabc",
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new(" \t"),
            content: ['abc']
          )
        ],
        [
          ' `a`bc',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new(' '),
            content: [Cosensee::Code.new('a'), 'bc']
          )
        ],
        [
          'a`b`c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['a', Cosensee::Code.new('b'), 'c']
          )
        ],
        [
          '> a`b`c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::Quote.new('>'),
            content: [' a', Cosensee::Code.new('b'), 'c']
          )
        ],
        [
          'code:',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['code:']
          )
        ],
        [
          'code:a`b`c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::Codeblock.new('a`b`c')
          )
        ],
        [
          '$ a b c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::CommandLine.new(content: 'a b c', prompt: '$')
          )
        ],
        [
          '$ a [b] c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::CommandLine.new(content: 'a [b] c', prompt: '$')
          )
        ],
        [
          '$ a `b` c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::CommandLine.new(content: 'a `b` c', prompt: '$')
          )
        ],
        [
          '[',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['[']
          )
        ],
        [
          '[]',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: [Cosensee::EmptyBracket.new([''])]
          )
        ],
        [
          '[abc]',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: [Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc')]
          )
        ],
        [
          '12[abc]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['12', Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc'), '34']
          )
        ],
        [
          'a[[b[]c]]d[e]f',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['a', Cosensee::DoubleBracket.new('b[]c'), 'd', Cosensee::InternalLinkBracket.new(content: ['e'], link: 'e.html', anchor: 'e'), 'f']
          )
        ],
        [
          '12 #abc 34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['12 ', Cosensee::HashTag.new('abc'), ' 34']
          )
        ],
        [
          '12[a`bc]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['12', Cosensee::InternalLinkBracket.new(content: ['a`bc'], link: 'a%60bc.html', anchor: 'a`bc'), '34']
          )
        ],
        [
          '12[a`bc]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['12', Cosensee::InternalLinkBracket.new(content: ['a`bc'], link: 'a%60bc.html', anchor: 'a`bc'), '34']
          )
        ],
        [
          '   12[a`b`c]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new('   '),
            content: ['12', Cosensee::TextBracket.new(['a', Cosensee::Code.new('b'), 'c']), '34']
          )
        ],
        [
          '   12[ https://example.com #foo bar]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new('   '),
            content: [
              '12',
              Cosensee::TextBracket.new(
                [
                  ' ',
                  Cosensee::Link.new('https://example.com'),
                  ' ',
                  Cosensee::HashTag.new('foo'),
                  ' bar'
                ]
              ),
              '34'
            ]
          )
        ]
      ]
    end

    with_them do
      it 'is parsed as ParsedLine' do
        expect(parser.parse(source)).to eq parsed
      end
    end
  end
end
