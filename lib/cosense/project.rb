# frozen_string_literal: true

require 'json'

module Cosense
  class Project
    def self.parse(source)
      json = JSON.parse(source, symbolize_names: true)
      name, display_name, exported, users, pages = json.values_at(:name, :displayName, :exported, :users, :pages)
      Cosense::Project.new(name:, display_name:, exported:, users:, pages:, source:)
    end

    def self.parse_file(filename)
      src = File.read(filename)
      self.parse(src)
    end

    attr_reader :name, :display_name, :exported, :users, :pages

    def initialize(name:, display_name:, exported:, users:, pages:, source:)
      @source = source
      @name = name
      @display_name = display_name
      @exported = Time.at(exported)
      @users = Cosense::User.create(users)
      @pages = Cosense::Page.create(pages)
      @source = source
    end

    def to_obj
      {name:, displayName: display_name, exported: exported.to_i, users:, pages:}
    end

    def to_json(*args)
      to_obj.to_json(*args)
    end
  end
end
