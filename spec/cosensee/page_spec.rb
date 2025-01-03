# frozen_string_literal: true

RSpec.describe Cosensee::Page do
  let(:page_hash) do
    {
      title: 'テストページ1',
      created: 1_732_018_000,
      updated: 1_732_020_000,
      id: '673c819d2c4025543126d6af',
      views: 12,
      lines: [
        'テスト1',
        '',
        '[テスト2]と[test3]',
        '',
        "\tテスト4",
        "\tテスト5",
        'https://example.com/test/',
        ''
      ]
    }
  end

  describe '.from_hash' do
    it 'is a Hash' do
      page = Cosensee::Page.from_hash(page_hash)
      expect(page.id).to eq '673c819d2c4025543126d6af'
      expect(page.created).to eq Time.new('2024-11-19 21:06:40')
      expect(page.updated).to eq Time.new('2024-11-19 21:40:00')
      expect(page.title).to eq 'テストページ1'
      expect(page.views).to eq 12
      expect(page.lines).to eq ['テスト1', '', '[テスト2]と[test3]', '', "\tテスト4", "\tテスト5", 'https://example.com/test/', '']
    end
  end

  describe '.new' do
    it 'is keyword arguments' do
      page = Cosensee::Page.new(**page_hash)

      expect(page.id).to eq '673c819d2c4025543126d6af'
      expect(page.created).to eq Time.new('2024-11-19 21:06:40')
      expect(page.updated).to eq Time.new('2024-11-19 21:40:00')
      expect(page.title).to eq 'テストページ1'
      expect(page.views).to eq 12
      expect(page.lines).to eq ['テスト1', '', '[テスト2]と[test3]', '', "\tテスト4", "\tテスト5", 'https://example.com/test/', '']
    end
  end

  describe '.from_array' do
    it 'is an Array' do
      pages = Cosensee::Page.from_array([page_hash])
      expect(pages.size).to eq 1

      expect(pages[0].id).to eq '673c819d2c4025543126d6af'
      expect(pages[0].created).to eq Time.new('2024-11-19 21:06:40')
      expect(pages[0].updated).to eq Time.new('2024-11-19 21:40:00')
      expect(pages[0].title).to eq 'テストページ1'
      expect(pages[0].views).to eq 12
      expect(pages[0].lines).to eq ['テスト1', '', '[テスト2]と[test3]', '', "\tテスト4", "\tテスト5", 'https://example.com/test/',
                                    '']
    end
  end

  describe '#parsed_lines' do
    it 'parse' do
      page = Cosensee::Page.new(**page_hash)

      expect(page.parsed_lines).to eq [
        Cosensee::ParsedLine.new(
          indent: Cosensee::Indent.new,
          content: []
        ),
        Cosensee::ParsedLine.new(
          indent: Cosensee::Indent.new,
          content: [
            Cosensee::InternalLinkBracket.new(content: ['テスト2'], link: '%E3%83%86%E3%82%B9%E3%83%882.html', anchor: 'テスト2'),
            'と',
            Cosensee::InternalLinkBracket.new(content: ['test3'], link: 'test3.html', anchor: 'test3')
          ]
        ),
        Cosensee::ParsedLine.new(
          indent: Cosensee::Indent.new,
          content: []
        ),
        Cosensee::ParsedLine.new(
          indent: Cosensee::Indent.new("\t"),
          content: ['テスト4']
        ),
        Cosensee::ParsedLine.new(
          indent: Cosensee::Indent.new("\t"),
          content: ['テスト5']
        ),
        Cosensee::ParsedLine.new(
          indent: Cosensee::Indent.new,
          content: ['https://example.com/test/']
        ),
        Cosensee::ParsedLine.new(
          indent: Cosensee::Indent.new,
          content: []
        )
      ]
    end
  end
end
