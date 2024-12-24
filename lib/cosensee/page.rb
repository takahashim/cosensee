# frozen_string_literal: true

require 'json'
# require 'uri'

module Cosensee
  # for Page
  class Page
    def self.create(obj)
      case obj
      when Array
        obj.map { |args| new(**args) }
      when Hash
        new(**obj)
      else
        raise Cosensee::Error, "invalid data: #{obj}"
      end
    end

    attr_reader :id, :title, :created, :updated, :views, :lines

    def initialize(id:, title:, created:, updated:, views:, lines:)
      @id = id
      @title = title
      @created = Time.at(created)
      @updated = Time.at(updated)
      @views = views
      @lines = lines
    end

    def parsed_lines
      Cosensee::Line.create(body_lines).map(&:parsed)
    end

    def body_lines
      lines.drop(1)
    end

    def some_images?
      lines.any?(&:some_image?)
    end

    def first_image
      lines.each do |line|
        return line.first_image if line.some_image?
      end
    end

    def link_path
      # body = URI.encode_www_form_component(title.gsub(/ /, '_'))
      body = title.gsub(/ /, '_').gsub(/\//, '%2F')

      "#{body}.html"
    end

    def ==(other)
      other.is_a?(Cosensee::Page) &&
        other.id == id &&
        other.title == title &&
        other.created == created &&
        other.updated == updated &&
        other.views == views &&
        other.lines == lines
    end

    def to_obj
      { id:, title:, created: created.to_i, updated: updated.to_i, views:, lines: }
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
