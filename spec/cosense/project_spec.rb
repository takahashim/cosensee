# frozen_string_literal: true

RSpec.describe Cosense::Project do
  let(:project_hash) do
    {
      name: "sample1",
      displayName: "sample 1",
      exported: 1732020000,
      users: [
        {
          id: "12ab34cd",
          name: "test_taro",
          displayName: "テスト太郎",
          email: "taro@example.jp"
        }
      ],
      pages: [
        {
          id: "673c819d2c4025543126d6af",
          title: "テストページ1",
          created: 1732018000,
          updated: 1732020000,
          views: 12,
          lines: [
            "テスト1",
            "",
            "[テスト2]と[test3]",
            "",
            "\tテスト4",
            "\tテスト5",
            "https://expample.com/test/",
            ""
          ]
        }
      ]
    }
  end

  describe '.parse' do
    it 'is a JSON' do
      json = project_hash.to_json
      project = Cosense::Project.parse(json)

      expect(project.name).to eq "sample1"
      expect(project.display_name).to eq "sample 1"
      expect(project.exported).to eq Time.new("2024-11-19 21:40:00")
      expect(project.users).to eq [Cosense::User.new(id: "12ab34cd", displayName: "テスト太郎", name: "test_taro", email: "taro@example.jp")]
      page = project_hash[:pages][0]
      expect(project.pages).to eq [Cosense::Page.new(id: "673c819d2c4025543126d6af", title: "テストページ1", created: 1732018000, updated: 1732020000, views: 12, lines: page[:lines])]
    end
  end

  describe '#to_json' do
    it 'returns a JSON' do
      json = project_hash.to_json
      project = Cosense::Project.parse(json)
      json2 = project.to_json
      expect(json).to eq json2
    end
  end
end
