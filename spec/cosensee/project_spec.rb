# frozen_string_literal: true

RSpec.describe Cosensee::Project do
  let(:project_hash) do
    {
      name: 'sample1',
      displayName: 'sample 1',
      exported: 1732020000,
      users: [
        {
          id: '12ab34cd',
          name: 'test_taro',
          displayName: 'テスト太郎',
          email: 'taro@example.jp'
        }
      ],
      pages: [
        {
          id: '673c819d2c4025543126d6af',
          title: 'テストページ1',
          created: 1732018000,
          updated: 1732020000,
          views: 12,
          lines: [
            'テスト1',
            '',
            '[テスト2]と[test3]',
            '',
            "\tテスト4",
            "\tテスト5",
            'https://expample.com/test/',
            ''
          ]
        }
      ]
    }
  end
  let(:renderer_class) { Cosensee::TailwindRenderer }

  describe '.parse' do
    it 'parses a JSON data' do
      json = project_hash.to_json
      project = Cosensee::Project.parse(json, renderer_class:)

      expect(project.name).to eq 'sample1'
      expect(project.display_name).to eq 'sample 1'
      expect(project.exported.utc).to eq Time.new('2024-11-19 12:40:00 UTC')
      expect(project.users).to eq [
        Cosensee::User.new(
          id: '12ab34cd',
          displayName: 'テスト太郎',
          name: 'test_taro',
          email: 'taro@example.jp'
        )
      ]
      page = project_hash[:pages][0]
      expect(project.pages).to eq [
        Cosensee::Page.new(
          id: '673c819d2c4025543126d6af',
          title: 'テストページ1',
          created: 1732018000,
          updated: 1732020000,
          views: 12,
          lines: page[:lines]
        )
      ]
    end
  end

  describe '.parse_file' do
    it 'parses JSON file' do
      project = Cosensee::Project.parse_file('spec/assets/project1.json', renderer_class:)

      expect(project.name).to eq 'sample1'
      expect(project.display_name).to eq 'sample 1'
      expect(project.exported.utc).to eq Time.new('2024-11-19 12:40:00 UTC')
      expect(project.users).to eq [
        Cosensee::User.new(
          id: '12ab34cd',
          displayName: 'テスト太郎',
          name: 'test_taro',
          email: 'taro@example.jp'
        )
      ]
      page = project_hash[:pages][0]
      expect(project.pages).to eq [
        Cosensee::Page.new(
          id: '673c819d2c4025543126d6af',
          title: 'テストページ1',
          created: 1732018000,
          updated: 1732020000,
          views: 12,
          lines: page[:lines]
        )
      ]
    end
  end

  describe '#to_json' do
    it 'returns a JSON' do
      json = project_hash.to_json
      project = Cosensee::Project.parse(json, renderer_class:)
      json2 = project.to_json
      expect(json).to eq json2
    end
  end
end
