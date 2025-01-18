# frozen_string_literal: true

require 'json'

module Cosensee
  # for Project
  class Project
    extend Delegatable

    def self.parse(source, renderer_class:)
      json = JSON.parse(source, symbolize_names: true)
      name, display_name, exported, users, pages = json.values_at(:name, :displayName, :exported, :users, :pages)
      Cosensee::Project.new(name:, display_name:, exported:, users:, pages:, source:, renderer_class:)
    end

    def self.parse_file(filename, renderer_class:)
      src = File.read(filename)
      parse(src, renderer_class:)
    end

    def initialize(name:, exported:, users:, pages:, source:, renderer_class:, **kwargs)
      @name = name
      @display_name = if kwargs.keys.size == 1 && kwargs.key?(:display_name)
                        kwargs[:display_name]
                      elsif kwargs.keys.size == 1 && kwargs.key?(:displayName)
                        kwargs[:displayName]
                      else
                        raise Cosensee::Error, 'Cosensee::User.new need an argument :display_name or :displayName'
                      end
      @users = Cosensee::User.from_array(users)
      @pages = Cosensee::Page.from_array(pages)
      @exported = Time.at(exported)
      @source = source

      @page_store = PageStore.new(project: self)
      @renderer_class = renderer_class
    end

    attr_reader :name, :display_name, :users, :pages, :exported, :source, :page_store, :renderer_class

    delegate :orphan_page_titles, :dump_search_data, :find_page_by_title, to: :page_store

    def sorted_pages_for_top
      pinned_pages = page_store.pinned_pages
      if pinned_pages.empty?
        pages.sort_by(&:updated).reverse
      else
        unpinned_pages = pages - pinned_pages
        pinned_pages + unpinned_pages.sort_by(&:updated).reverse
      end
    end

    def to_obj
      { name:, displayName: display_name, exported: exported.to_i, users:, pages: }
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
