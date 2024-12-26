# frozen_string_literal: true

require 'json'

module Cosensee
  # for Project
  Project = Data.define(:name, :display_name, :exported, :users, :pages, :source) do
    def self.parse(source)
      json = JSON.parse(source, symbolize_names: true)
      name, display_name, exported, users, pages = json.values_at(:name, :displayName, :exported, :users, :pages)
      Cosensee::Project.new(name:, display_name:, exported:, users:, pages:, source:)
    end

    def self.parse_file(filename)
      src = File.read(filename)
      parse(src)
    end

    def initialize(name:, exported:, users:, pages:, source:, **kwargs)
      display_name = if kwargs.keys.size == 1 && kwargs.key?(:display_name)
                       kwargs[:display_name]
                     elsif kwargs.keys.size == 1 && kwargs.key?(:displayName)
                       kwargs[:displayName]
                     else
                       raise Cosensee::Error, 'Cosensee::User.new need an argument :display_name or :displayName'
                     end

      super(
        name:,
        display_name:,
        exported: Time.at(exported),
        users: Cosensee::User.from_array(users),
        pages: Cosensee::Page.from_array(pages),
        source:
      )
    end

    def find_page(title)
      collect_page_titles unless @page_index_list

      pages[@page_index_list[title]]
    end

    def collect_page_titles
      @page_index_list = {}
      pages.each_with_index do |page, ind|
        @page_index_list[page.title] = ind
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
