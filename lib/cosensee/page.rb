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
      super(
        id:,
        title:,
        created: Time.at(created),
        updated: Time.at(updated),
        views:,
        lines:
      )
    end

    def parsed_lines
      Cosensee::Line.from_array(body_lines).map(&:parsed)
    end

    def body_lines
      lines.drop(1)
    end

    def some_images?
      lines.any?(&:some_image?)
    end

    def first_image
      lines.find(&:some_image?)&.first_image
    end

    def link_path
      # body = URI.encode_www_form_component(title.gsub(/ /, '_'))
      body = title.gsub(/ /, '_').gsub('/', '%2F')

      "#{body}.html"
    end

    def to_html
      tailwind_renderer = Cosensee::TailwindRenderer.new(content: self)
      tailwind_renderer.render
    end

    def to_obj
      { id:, title:, created: created.to_i, updated: updated.to_i, views:, lines: }
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
