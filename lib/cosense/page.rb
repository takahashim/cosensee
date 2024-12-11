# frozen_string_literal: true

require 'json'

module Cosense
  # for Page
  class Page
    def self.create(obj)
      case obj
      when Array
        obj.map { |args| new(**args) }
      when Hash
        new(**obj)
      else
        raise Cosense::Error, "invalid data: #{obj}"
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
      lines.any? { |line| line.strip.match?(/\A\[.*\.(png|jpg)\]\z/) }
    end

    def first_image
      lines.each do |line|
        return line.strip.gsub(/\A\[/).gsub(/\]\z/) if line.strip.match?(/\A\[.*\.(png|jpg)\]\z/)
      end
    end

    def link_path
      "#{title}.html"
    end

    def ==(other)
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
