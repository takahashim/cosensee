# frozen_string_literal: true

RSpec.describe Cosense::User do
  describe '.create' do
    let(:user_hash) do
      {
        id: "12ab34cd",
        name: "test_taro",
        displayName: "テスト太郎",
        email: "taro@example.jp"
      }
    end
    let(:user_hash2) do
      {
        id: "aaaabbbbb00001111",
        name: "test_taro2",
        displayName: "テスト二太郎",
        email: "2taro@example.jp"
      }
    end

    it 'is a Hash' do
      user = Cosense::User.create(**user_hash)

      expect(user.id).to eq "12ab34cd"
      expect(user.name).to eq "test_taro"
      expect(user.display_name).to eq "テスト太郎"
      expect(user.email).to eq "taro@example.jp"
    end

    it 'is an Array' do
      users = Cosense::User.create([user_hash])
      expect(users.size).to eq 1

      expect(users[0].id).to eq "12ab34cd"
      expect(users[0].name).to eq "test_taro"
      expect(users[0].display_name).to eq "テスト太郎"
      expect(users[0].email).to eq "taro@example.jp"
    end

    it 'is an Array of 2 items' do
      users = Cosense::User.create([user_hash, user_hash2])
      expect(users.size).to eq 2

      expect(users[0].id).to eq "12ab34cd"
      expect(users[0].name).to eq "test_taro"
      expect(users[0].display_name).to eq "テスト太郎"
      expect(users[0].email).to eq "taro@example.jp"

      expect(users[1].id).to eq "aaaabbbbb00001111"
      expect(users[1].name).to eq "test_taro2"
      expect(users[1].display_name).to eq "テスト二太郎"
      expect(users[1].email).to eq "2taro@example.jp"
    end
  end
end
