# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::PageStore do
  let(:project) { build(:project, pages:) }
  let(:page_store) { project.page_store }
  let(:pages) do
    [
      build(:page, title: 'HOME', lines: ['HOME', 'line [Page2]'], updated: create_utc_timestamp(2025, 1, 1)),
      build(:page, title: 'Page1', lines: ['Page1', 'line [HOME]'], updated: create_utc_timestamp(2025, 1, 2)),
      build(:page, title: 'Page2', lines: ['Page2', 'line [Page1] [OrphanPage]'], updated: create_utc_timestamp(2025, 1, 3)),
      build(:page, title: 'Page3', lines: ['Page3', 'line 1'], updated: create_utc_timestamp(2025, 1, 4))
    ]
  end

  describe '#orphan_page_titles' do
    it 'returns titles of pages that are not linked to by any other page' do
      page_store.setup_link_indexes
      expect(page_store.orphan_page_titles).to eq(['OrphanPage'])
    end
  end

  describe '#create_title_index' do
    it 'creates a hash index with page titles as keys and pages as values' do
      index = page_store.create_title_index(pages)
      expect(index.keys).to contain_exactly('HOME', 'Page1', 'Page2', 'Page3')
      expect(index['HOME'].title).to eq('HOME')
    end
  end

  describe '#pinned_pages' do
    it 'returns the pages corresponding to the pin_titles' do
      result = page_store.pinned_pages
      expect(result.map(&:title)).to eq(['HOME'])
    end
  end

  describe '#find_link_pages_by_title' do
    it 'returns linking and linked pages sorted by updated time in descending order' do
      page_store.setup_link_indexes
      result = page_store.find_link_pages_by_title('HOME')
      expect(result.map(&:title)).to eq(%w[Page2 Page1])
    end
  end
end
