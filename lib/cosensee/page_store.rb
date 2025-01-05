# frozen_string_literal: true

require 'json'
# require 'uri'

module Cosensee
  # To search for pages
  class PageStore
    def initialize(project:)
      @project = project
      @pages = project.pages
      @pages_by_title = nil
      @pages_by_links = nil
      # @pages_by_links = create_link_index(project)
    end

    def pages_by_title
      @pages_by_title ||= create_title_index(@pages)
    end

    def pages_by_links
      # @pages_by_links ||= create_links_index(project)
    end

    def create_title_index(pages)
      list = {}
      pages.each_with_index do |page, ind|
        list[page.title] = ind
      end
      list
    end
  end
end
