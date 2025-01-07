# frozen_string_literal: true

require 'json'
# require 'uri'

module Cosensee
  # To search for pages
  class PageStore
    DEFAULT_PIN_TITLES = ['HOME'] # rubocop:disable Style/MutableConstant

    def initialize(project:)
      @project = project
      @pages = project.pages
      @pages_by_title = nil
      @linking_pages = nil
      @linked_pages = nil
      @pin_titles = DEFAULT_PIN_TITLES
    end

    attr_reader :pin_titles

    def pages_by_title
      @pages_by_title ||= create_title_index(@pages)
    end

    def find_page_by_title(title)
      pages_by_title[title]
    end

    def linking_pages
      setup_link_indexes unless @linking_pages

      @linking_pages
    end

    def linked_pages
      setup_link_indexes unless @linked_pages

      @linked_pages
    end

    def title_exist?(title)
      !!pages_by_title[title]
    end

    def orphan_page_titles
      linked_pages.keys.reject { |title| title_exist?(title) }
    end

    def create_title_index(pages)
      pages.each_with_object({}) do |page, hash|
        hash[page.title] = page
      end
    end

    def pinned_pages
      pages_by_title.fetch_values(*pin_titles)
    end

    def find_link_pages_by_title(title)
      pages = linking_pages[title] + linked_pages[title]
      pages.sort_by(&:updated).uniq.reverse
    end

    def setup_link_indexes
      @linking_pages = Hash.new { |h, k| h[k] = [] }
      @linked_pages = Hash.new { |h, k| h[k] = [] }
      @project.pages.each do |page|
        page.linking_page_titles.each do |linking_title|
          @linking_pages[page.title] << pages_by_title[linking_title] if pages_by_title[linking_title]
          @linked_pages[linking_title] << page
        end
      end
    end
  end
end
