# frozen_string_literal: true

RSpec.describe Cosense::Page do
  describe '.create' do
    let(:page_hash) do
      {
        title: "テストページ1",
        created: 1732018000,
        updated: 1732020000,
        id: "673c819d2c4025543126d6af",
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
    end

    it 'is a Hash' do
      page = Cosense::Page.create(page_hash)

      expect(page.id).to eq "673c819d2c4025543126d6af"
      expect(page.created).to eq Time.new("2024-11-19 21:06:40")
      expect(page.updated).to eq Time.new("2024-11-19 21:40:00")
      expect(page.title).to eq "テストページ1"
      expect(page.views).to eq 12
      expect(page.lines).to eq ["テスト1", "", "[テスト2]と[test3]", "", "\tテスト4", "\tテスト5", "https://expample.com/test/", ""]
    end

    it 'is keyword arguments' do
      page = Cosense::Page.create(**page_hash)

      expect(page.id).to eq "673c819d2c4025543126d6af"
      expect(page.created).to eq Time.new("2024-11-19 21:06:40")
      expect(page.updated).to eq Time.new("2024-11-19 21:40:00")
      expect(page.title).to eq "テストページ1"
      expect(page.views).to eq 12
      expect(page.lines).to eq ["テスト1", "", "[テスト2]と[test3]", "", "\tテスト4", "\tテスト5", "https://expample.com/test/", ""]
    end

    it 'is an Array' do
      pages = Cosense::Page.create([page_hash])
      expect(pages.size).to eq 1

      expect(pages[0].id).to eq "673c819d2c4025543126d6af"
      expect(pages[0].created).to eq Time.new("2024-11-19 21:06:40")
      expect(pages[0].updated).to eq Time.new("2024-11-19 21:40:00")
      expect(pages[0].title).to eq "テストページ1"
      expect(pages[0].views).to eq 12
      expect(pages[0].lines).to eq ["テスト1", "", "[テスト2]と[test3]", "", "\tテスト4", "\tテスト5", "https://expample.com/test/", ""]
    end
  end
end
