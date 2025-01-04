# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::LineParser do
  let(:parser) { Cosensee::LineParser.new }

  describe '#parse_indent' do
    it 'parse indent segments' do
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Indent.new, rest: '')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: ' '))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Indent.new(' '), rest: '')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: ' a'))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Indent.new(' '), rest: 'a')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: " \t"))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Indent.new(" \t"), rest: '')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: " \ta"))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Indent.new(" \t"), rest: 'a')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: " b\ta"))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Indent.new(' '), rest: "b\ta")
    end
  end

  describe '#parse_whole_line' do
    it 'parse command line' do
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'a$'))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: 'a$')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '$ '))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '$ ')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '$ a'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::CommandLine.new(content: 'a', prompt: '$'), rest: nil, parsed: true)
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '% ab'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::CommandLine.new(content: 'ab', prompt: '%'), rest: nil, parsed: true)
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '%% a'))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '%% a')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '% a $ b'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::CommandLine.new(content: 'a $ b', prompt: '%'), rest: nil, parsed: true)
    end

    it 'parse quote segments' do
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'a>'))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: 'a>')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '>'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Quote.new('>'), rest: '')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '>ab'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Quote.new('>'), rest: 'ab')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '>>b'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Quote.new('>'), rest: '>b')
    end

    it 'parse codeblock segments' do
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'code:'))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: 'code:')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'code:abc'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Codeblock.new('abc'), rest: nil, parsed: true)
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'code:abc def'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Codeblock.new('abc def'), rest: nil, parsed: true)
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'code:abc[] `de`f'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Codeblock.new('abc[] `de`f'), rest: nil, parsed: true)
    end
  end

  describe '#parse_hastag' do
    it 'parse hashtag segments' do
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: ['']))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: ['#']))).to eq Cosensee::ParsedLine.new(content: ['#'])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: ['#a']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::HashTag.new('a')])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: [' #a!#b']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::HashTag.new('a!#b')])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: [' #abc ']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::HashTag.new('abc'), ' '])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: [' #あいうえお ']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::HashTag.new('あいうえお'), ' '])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: ['#a #b #c']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::HashTag.new('a'), ' ', Cosensee::HashTag.new('b'), ' ', Cosensee::HashTag.new('c')])
    end
  end

  describe '#parse_code' do
    it 'parse code segments' do
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: '`'))).to eq Cosensee::ParsedLine.new(content: ['`'])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: '``'))).to eq Cosensee::ParsedLine.new(content: ['', Cosensee::Code.new(''), ''])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: 'a`b`'))).to eq Cosensee::ParsedLine.new(content: ['a', Cosensee::Code.new('b'), ''])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: 'a`b`c'))).to eq Cosensee::ParsedLine.new(content: ['a', Cosensee::Code.new('b'), 'c'])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: 'a`b`c`d'))).to eq Cosensee::ParsedLine.new(content: ['a', Cosensee::Code.new('b'), 'c`d'])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: 'a`b`c`d`'))).to eq Cosensee::ParsedLine.new(content: ['a', Cosensee::Code.new('b'), 'c', Cosensee::Code.new('d'), ''])
    end
  end

  describe '#parse_url' do
    it 'parse code segments' do
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['']))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['https://']))).to eq Cosensee::ParsedLine.new(content: ['https://'])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['https://example.com']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Link.new('https://example.com')])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['https://example.com  ']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Link.new('https://example.com'), '  '])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: [' https://example.com ']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::Link.new('https://example.com'), ' '])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: [' https://example.com/あいうえお ']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::Link.new('https://example.com/あいうえお'), ' '])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['https://example.com https://example.org']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Link.new('https://example.com'), ' ', Cosensee::Link.new('https://example.org')])
    end
  end

  describe '#parse_double_bracket' do
    it 'parse double bracket segments' do
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['']))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[']))).to eq Cosensee::ParsedLine.new(content: ['['])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[]']))).to eq Cosensee::ParsedLine.new(content: ['[]'])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[[]]']))).to eq Cosensee::ParsedLine.new(content: ['[[]]'])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[[a]]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::DoubleBracket.new('a')])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[[a[b]c]]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::DoubleBracket.new('a[b]c')])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[[a[[[[a[[]aa` ]]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::DoubleBracket.new('a[[[[a[[]aa` ')])
    end
  end

  describe '#parse_bracket' do
    it 'parse bracket segments' do
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['']))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[']))).to eq Cosensee::ParsedLine.new(content: ['['])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::EmptyBracket.new([''])])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[abc]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc')])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['12[abc]34']))).to eq Cosensee::ParsedLine.new(content: ['12', Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc'), '34'])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[abc]12[xyz]']))).to eq Cosensee::ParsedLine.new(content: [
                                                                                                                         Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc'),
                                                                                                                         '12',
                                                                                                                         Cosensee::InternalLinkBracket.new(content: ['xyz'], link: 'xyz.html', anchor: 'xyz')
                                                                                                                       ])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[abc]12[xyz']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc'), '12[xyz'])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[a', Cosensee::Code.new('b'), 'c]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::TextBracket.new(['a', Cosensee::Code.new('b'), 'c'])])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[a', Cosensee::Code.new('b'), 'c']))).to eq Cosensee::ParsedLine.new(content: ['[a', Cosensee::Code.new('b'), 'c'])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['x[a', Cosensee::Code.new('b'), 'c', 'd]e']))).to eq Cosensee::ParsedLine.new(content: ['x', Cosensee::TextBracket.new(['a', Cosensee::Code.new('b'), 'cd']), 'e'])
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
            content: [],
            parsed: true
          )
        ],
        [
          ' ',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new(' '),
            content: [],
            parsed: true
          )
        ],
        [
          'a',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['a'],
            parsed: true
          )
        ],
        [
          ' a',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new(' '),
            content: ['a'],
            parsed: true
          )
        ],
        [
          " \tabc",
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new(" \t"),
            content: ['abc'],
            parsed: true
          )
        ],
        [
          ' `a`bc',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new(' '),
            content: [Cosensee::Code.new('a'), 'bc'],
            parsed: true
          )
        ],
        [
          'a`b`c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['a', Cosensee::Code.new('b'), 'c'],
            parsed: true
          )
        ],
        [
          '> a`b`c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::Quote.new('>'),
            content: [' a', Cosensee::Code.new('b'), 'c'],
            parsed: true
          )
        ],
        [
          'code:',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['code:'],
            parsed: true
          )
        ],
        [
          'code:a`b`c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::Codeblock.new('a`b`c'),
            parsed: true
          )
        ],
        [
          '$ a b c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::CommandLine.new(content: 'a b c', prompt: '$'),
            parsed: true
          )
        ],
        [
          '$ a [b] c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::CommandLine.new(content: 'a [b] c', prompt: '$'),
            parsed: true
          )
        ],
        [
          '$ a `b` c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            line_content: Cosensee::CommandLine.new(content: 'a `b` c', prompt: '$'),
            parsed: true
          )
        ],
        [
          '[',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['['],
            parsed: true
          )
        ],
        [
          '[]',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: [Cosensee::EmptyBracket.new([''])],
            parsed: true
          )
        ],
        [
          '[abc]',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: [Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc')],
            parsed: true
          )
        ],
        [
          '12[abc]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['12', Cosensee::InternalLinkBracket.new(content: ['abc'], link: 'abc.html', anchor: 'abc'), '34'],
            parsed: true
          )
        ],
        [
          'a[[b[]c]]d[e]f',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['a', Cosensee::DoubleBracket.new('b[]c'), 'd', Cosensee::InternalLinkBracket.new(content: ['e'], link: 'e.html', anchor: 'e'), 'f'],
            parsed: true
          )
        ],
        [
          '12 #abc 34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['12 ', Cosensee::HashTag.new('abc'), ' 34'],
            parsed: true
          )
        ],
        [
          '12[a`bc]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['12', Cosensee::InternalLinkBracket.new(content: ['a`bc'], link: 'a%60bc.html', anchor: 'a`bc'), '34'],
            parsed: true
          )
        ],
        [
          '12[a`bc]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new,
            content: ['12', Cosensee::InternalLinkBracket.new(content: ['a`bc'], link: 'a%60bc.html', anchor: 'a`bc'), '34'],
            parsed: true
          )
        ],
        [
          '   12[a`b`c]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Indent.new('   '),
            content: ['12', Cosensee::TextBracket.new(['a', Cosensee::Code.new('b'), 'c']), '34'],
            parsed: true
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
            ],
            parsed: true
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
