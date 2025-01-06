# frozen_string_literal: true

require 'json'
# require 'uri'

module Cosensee
  # for Page
  Page = Data.define(:id, :title, :created, :updated, :views, :lines) do
    def self.from_array(args_list)
      args_list.map { |args| new(**args) }
    end

    def self.from_hash(obj)
      new(**obj)
    end

    def initialize(id:, title:, created:, updated:, views:, lines:)
      @parsed_lines = lines.drop(1).map { |arg| LineParser.parse(arg) }
      @linking_page_titles = @parsed_lines.map(&:internal_links).flatten

      super(
        id:,
        title:,
        created: Time.at(created),
        updated: Time.at(updated),
        views:,
        lines:
      )
    end

    attr_accessor :parsed_lines, :linking_page_titles

    def body_lines
      lines.drop(1)
    end

    def link_path
      # body = URI.encode_www_form_component(title.gsub(/ /, '_'))
      body = title.gsub(/ /, '_').gsub('/', '%2F')

      "#{body}.html"
    end

    def to_html
      Cosensee::TailwindRenderer.new(content: self).render
    end

    def to_obj
      { id:, title:, created: created.to_i, updated: updated.to_i, views:, lines: }
    end

    def to_json(*)
      to_obj.to_json(*)
    end

    def inspect
      "#<data Cosensee::Page id: #{id}, title: #{title}>"
    end
  end
end
