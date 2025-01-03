# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::LinkEncodable do
  include Cosensee::LinkEncodable

  describe '#encode_link' do
    it 'encodes special characters with % encoding' do
      expect(encode_link('%^`{|}')).to eq('%25%5E%60%7B%7C%7D')
    end

    it 'does not encode unescaped characters' do
      expect(encode_link('A-Za-z0-9!"$&\'()-~@+;:*<>,._')).to eq('A-Za-z0-9!"$&\'()-~@+;:*<>,._')
    end

    it 'replaces spaces with underscores' do
      expect(encode_link('Hello World')).to eq('Hello_World')
    end

    it 'encodes mixed characters correctly' do
      expect(encode_link('Hello World!%^')).to eq('Hello_World!%25%5E')
    end

    it 'handles empty strings' do
      expect(encode_link('')).to eq('')
    end

    it 'encodes non-ASCII characters' do
      expect(encode_link('こんにちは World')).to eq('%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF_World')
    end

    it 'encodes special characters at the edges' do
      expect(encode_link('%Hello World!%')).to eq('%25Hello_World!%25')
    end
  end
end
