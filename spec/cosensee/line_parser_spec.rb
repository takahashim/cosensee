# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::LineParser do
  let(:parser) { Cosensee::LineParser.new }

  describe '#parse_indent' do
    it 'parse indent segments' do
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Node::Indent.new, rest: '')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: ' '))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Node::Indent.new(' ', ' '), rest: '')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: ' a'))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Node::Indent.new(' ', ' '), rest: 'a')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: " \t"))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Node::Indent.new(" \t", " \t"), rest: '')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: " \ta"))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Node::Indent.new(" \t", " \t"), rest: 'a')
      expect(parser.parse_indent(Cosensee::ParsedLine.new(rest: " b\ta"))).to eq Cosensee::ParsedLine.new(indent: Cosensee::Node::Indent.new(' ', ' '), rest: "b\ta")
    end
  end

  describe '#parse_whole_line' do
    it 'parse command line' do
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'a$'))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: 'a$')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '$ '))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '$ ')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '$ a'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Node::CommandLine.new(content: 'a', prompt: '$', raw: '$ a'), rest: nil, parsed: true)
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '% ab'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Node::CommandLine.new(content: 'ab', prompt: '%', raw: '% ab'), rest: nil, parsed: true)
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '%% a'))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '%% a')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '% a $ b'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Node::CommandLine.new(content: 'a $ b', prompt: '%', raw: '% a $ b'), rest: nil, parsed: true)
    end

    it 'parse quote segments' do
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'a>'))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: 'a>')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '>'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Node::Quote.new(nil, '>', '>'), rest: '')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '>ab'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Node::Quote.new(nil, '>ab', '>'), rest: 'ab')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: '>>b'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Node::Quote.new(nil, '>>b', '>'), rest: '>b')
    end

    it 'parse codeblock segments' do
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: '')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'code:'))).to eq Cosensee::ParsedLine.new(line_content: nil, rest: 'code:')
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'code:abc'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Node::Codeblock.new('', 'abc', 'code:abc'), rest: nil, parsed: true)
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'code:abc def'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Node::Codeblock.new('', 'abc def', 'code:abc def'), rest: nil, parsed: true)
      expect(parser.parse_whole_line(Cosensee::ParsedLine.new(rest: 'code:abc[] `de`f'))).to eq Cosensee::ParsedLine.new(line_content: Cosensee::Node::Codeblock.new('', 'abc[] `de`f', 'code:abc[] `de`f'), rest: nil, parsed: true)
    end
  end

  describe '#parse_hastag' do
    it 'parse hashtag segments' do
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: ['']))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: ['#']))).to eq Cosensee::ParsedLine.new(content: ['#'])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: ['#a']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::HashTag.new('a', '#a')])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: [' #a!#b']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::Node::HashTag.new('a!#b', '#a!#b')])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: [' #abc ']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::Node::HashTag.new('abc', '#abc'), ' '])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: [' #あいうえお ']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::Node::HashTag.new('あいうえお', '#あいうえお'), ' '])
      expect(parser.parse_hashtag(Cosensee::ParsedLine.new(content: ['#a #b #c']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::HashTag.new('a', '#a'), ' ', Cosensee::Node::HashTag.new('b', '#b'), ' ', Cosensee::Node::HashTag.new('c', '#c')])
    end
  end

  describe '#parse_code' do
    it 'parse code segments' do
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: ''))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: '`'))).to eq Cosensee::ParsedLine.new(content: ['`'])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: '``'))).to eq Cosensee::ParsedLine.new(content: ['', Cosensee::Node::Code.new('', '``'), ''])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: 'a`b`'))).to eq Cosensee::ParsedLine.new(content: ['a', Cosensee::Node::Code.new('b', '`b`'), ''])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: 'a`b`c'))).to eq Cosensee::ParsedLine.new(content: ['a', Cosensee::Node::Code.new('b', '`b`'), 'c'])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: 'a`b`c`d'))).to eq Cosensee::ParsedLine.new(content: ['a', Cosensee::Node::Code.new('b', '`b`'), 'c`d'])
      expect(parser.parse_code(Cosensee::ParsedLine.new(rest: 'a`b`c`d`'))).to eq Cosensee::ParsedLine.new(content: ['a', Cosensee::Node::Code.new('b', '`b`'), 'c', Cosensee::Node::Code.new('d', '`d`'), ''])
    end
  end

  describe '#parse_url' do
    it 'parse code segments' do
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['']))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['https://']))).to eq Cosensee::ParsedLine.new(content: ['https://'])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['https://example.com']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::Link.new('https://example.com', 'https://example.com')])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['https://example.com  ']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::Link.new('https://example.com', 'https://example.com'), '  '])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: [' https://example.com ']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::Node::Link.new('https://example.com', 'https://example.com'), ' '])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: [' https://example.com/あいうえお ']))).to eq Cosensee::ParsedLine.new(content: [' ', Cosensee::Node::Link.new('https://example.com/あいうえお', 'https://example.com/あいうえお'), ' '])
      expect(parser.parse_url(Cosensee::ParsedLine.new(content: ['https://example.com https://example.org']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::Link.new('https://example.com', 'https://example.com'), ' ', Cosensee::Node::Link.new('https://example.org', 'https://example.org')])
    end
  end

  describe '#parse_double_bracket' do
    it 'parse double bracket segments' do
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['']))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[']))).to eq Cosensee::ParsedLine.new(content: ['['])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[]']))).to eq Cosensee::ParsedLine.new(content: ['[]'])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[[]]']))).to eq Cosensee::ParsedLine.new(content: ['[[]]'])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[[a]]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::DoubleBracket.new(['a'], '[[a]]')])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[[a[b]c]]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::DoubleBracket.new(['a[b]c'], '[[a[b]c]]')])
      expect(parser.parse_double_bracket(Cosensee::ParsedLine.new(content: ['[[a[[[[a[[]aa` ]]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::DoubleBracket.new(['a[[[[a[[]aa` '], '[[a[[[[a[[]aa` ]]')])
    end
  end

  describe '#parse_bracket' do
    it 'parse bracket segments' do
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['']))).to eq Cosensee::ParsedLine.new(content: [])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[']))).to eq Cosensee::ParsedLine.new(content: ['['])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::EmptyBracket.new([''], '[]')])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[abc]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::InternalLinkBracket.new(content: ['abc'],  anchor: 'abc', raw: '[abc]')])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['12[abc]34']))).to eq Cosensee::ParsedLine.new(content: ['12', Cosensee::Node::InternalLinkBracket.new(content: ['abc'], anchor: 'abc', raw: '[abc]'), '34'])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[abc]12[xyz]']))).to eq Cosensee::ParsedLine.new(content: [
                                                                                                                         Cosensee::Node::InternalLinkBracket.new(content: ['abc'], anchor: 'abc', raw: '[abc]'),
                                                                                                                         '12',
                                                                                                                         Cosensee::Node::InternalLinkBracket.new(content: ['xyz'], anchor: 'xyz', raw: '[xyz]')
                                                                                                                       ])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[abc]12[xyz']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::InternalLinkBracket.new(content: ['abc'], anchor: 'abc', raw: '[abc]'), '12[xyz'])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[a', Cosensee::Node::Code.new('b', '`b`'), 'c]']))).to eq Cosensee::ParsedLine.new(content: [Cosensee::Node::TextBracket.new(['a', Cosensee::Node::Code.new('b', '`b`'), 'c'], '[a`b`c]')])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['[a', Cosensee::Node::Code.new('b', '`b`'), 'c']))).to eq Cosensee::ParsedLine.new(content: ['[a', Cosensee::Node::Code.new('b', '`b`'), 'c'])
      expect(parser.parse_bracket(Cosensee::ParsedLine.new(content: ['x[a', Cosensee::Node::Code.new('b', '`b`'), 'c', 'd]e']))).to eq Cosensee::ParsedLine.new(content: ['x', Cosensee::Node::TextBracket.new(['a', Cosensee::Node::Code.new('b', '`b`'), 'cd'], '[a`b`cd]'), 'e'])
    end
  end

  describe '#parse' do
    where(:source, :parsed) do
      [
        [
          '',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            line_content: nil,
            content: [],
            parsed: true
          )
        ],
        [
          ' ',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new(' ', ' '),
            content: [],
            parsed: true
          )
        ],
        [
          'a',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: ['a'],
            parsed: true
          )
        ],
        [
          ' a',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new(' ', ' '),
            content: ['a'],
            parsed: true
          )
        ],
        [
          " \tabc",
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new(" \t", " \t"),
            content: ['abc'],
            parsed: true
          )
        ],
        [
          ' `a`bc',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new(' ', ' '),
            content: [Cosensee::Node::Code.new('a', '`a`'), 'bc'],
            parsed: true
          )
        ],
        [
          'a`b`c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: ['a', Cosensee::Node::Code.new('b', '`b`'), 'c'],
            parsed: true
          )
        ],
        [
          '> a`b`c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            line_content: Cosensee::Node::Quote.new([' a', Cosensee::Node::Code.new('b', '`b`'), 'c'], '> a`b`c', '>'),
            content: [],
            parsed: true
          )
        ],
        [
          'code:',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: ['code:'],
            parsed: true
          )
        ],
        [
          'code:a`b`c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            line_content: Cosensee::Node::Codeblock.new(content: '', name: 'a`b`c', raw: 'code:a`b`c'),
            parsed: true
          )
        ],
        [
          '$ a b c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            line_content: Cosensee::Node::CommandLine.new(content: 'a b c', prompt: '$', raw: '$ a b c'),
            parsed: true
          )
        ],
        [
          '$ a [b] c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            line_content: Cosensee::Node::CommandLine.new(content: 'a [b] c', prompt: '$', raw: '$ a [b] c'),
            parsed: true
          )
        ],
        [
          '$ a `b` c',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            line_content: Cosensee::Node::CommandLine.new(content: 'a `b` c', prompt: '$', raw: '$ a `b` c'),
            parsed: true
          )
        ],
        [
          '[',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: ['['],
            parsed: true
          )
        ],
        [
          '[]',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: [Cosensee::Node::EmptyBracket.new([''], '[]')],
            parsed: true
          )
        ],
        [
          '[abc]',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: [Cosensee::Node::InternalLinkBracket.new(content: ['abc'], anchor: 'abc', raw: '[abc]')],
            parsed: true
          )
        ],
        [
          '[https://example.com/foo/bar.jpg]',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: [Cosensee::Node::ImageBracket.new(content: ['https://example.com/foo/bar.jpg'], link: nil, src: 'https://example.com/foo/bar.jpg', raw: '[https://example.com/foo/bar.jpg]')],
            parsed: true
          )
        ],
        [
          '12[abc]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: ['12', Cosensee::Node::InternalLinkBracket.new(content: ['abc'], anchor: 'abc', raw: '[abc]'), '34'],
            parsed: true
          )
        ],
        [
          'a[[b[]c]]d[e]f',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: ['a', Cosensee::Node::DoubleBracket.new(['b[]c'], '[[b[]c]]'), 'd', Cosensee::Node::InternalLinkBracket.new(content: ['e'], anchor: 'e', raw: '[e]'), 'f'],
            parsed: true
          )
        ],
        [
          '12 #abc 34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: ['12 ', Cosensee::Node::HashTag.new('abc', '#abc'), ' 34'],
            parsed: true
          )
        ],
        [
          'テストhttps://example.com/foo abc',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: ['テスト', Cosensee::Node::Link.new(content: 'https://example.com/foo', raw: 'https://example.com/foo'), ' abc'],
            parsed: true
          )
        ],
        [
          '12[a`bc]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new,
            content: ['12', Cosensee::Node::InternalLinkBracket.new(content: ['a`bc'], anchor: 'a`bc', raw: '[a`bc]'), '34'],
            parsed: true
          )
        ],
        [
          '   12[a`b`c]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new('   ', '   '),
            content: ['12', Cosensee::Node::TextBracket.new(['a', Cosensee::Node::Code.new('b', '`b`'), 'c'], '[a`b`c]'), '34'],
            parsed: true
          )
        ],
        [
          '   12[ https://example.com #foo bar]34',
          Cosensee::ParsedLine.new(
            indent: Cosensee::Node::Indent.new('   ', '   '),
            content: [
              '12',
              Cosensee::Node::TextBracket.new(
                [
                  ' ',
                  Cosensee::Node::Link.new('https://example.com', 'https://example.com'),
                  ' ',
                  Cosensee::Node::HashTag.new('foo', '#foo'),
                  ' bar'
                ],
                '[ https://example.com #foo bar]'
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
