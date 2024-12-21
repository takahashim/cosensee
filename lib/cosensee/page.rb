# frozen_string_literal: true

require 'json'

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
      "#{title}.html"
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
