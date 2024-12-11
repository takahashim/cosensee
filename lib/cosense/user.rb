# frozen_string_literal: true

require 'json'

module Cosense
  class User
    def self.create(obj)
      if obj.kind_of?(Array)
        obj.map{|args|  self.new(**args)}
      elsif obj.kind_of?(Hash)
        self.new(**obj)
      else
        raise Cosense::Error, "invalid data: #{obj}"
      end
    end

    attr_reader :id, :name, :display_name, :email

    def initialize(id:, name:, displayName:, email:)
      @id = id
      @display_name = displayName
      @name = name
      @email = email
    end

    def ==(other)
      other.id == id &&
        other.display_name == display_name &&
        other.name == name &&
        other.email == email
    end

    def to_obj
      {id:, name:, displayName: display_name, email:}
    end

    def to_json(*args)
      to_obj.to_json(*args)
    end
  end
end
