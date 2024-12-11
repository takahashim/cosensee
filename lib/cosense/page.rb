# frozen_string_literal: true

require 'json'

module Cosense
  # for Page
  class Page
    def self.create(obj)
      if obj.is_a?(Array)
        obj.map { |args| new(**args) }
      elsif obj.is_a?(Hash)
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
