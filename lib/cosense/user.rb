# frozen_string_literal: true

require 'json'

module Cosense
  # for User
  class User
    # allow Array and Hash (Object in JSON)
    def self.create(obj)
      if obj.is_a?(Array)
        obj.map { |args| new(**args) }
      elsif obj.is_a?(Hash)
        new(**obj)
      else
        raise Cosense::Error, "invalid data: #{obj}"
      end
    end

    attr_reader :id, :name, :display_name, :email

    # allow both `:display_key` and `:displayKey`
    def initialize(id:, name:, email:, **kwargs)
      display_name = if kwargs.keys == [:display_name]
                       kwargs[:display_name]
                     elsif kwargs.keys == [:displayName]
                       kwargs[:displayName]
                     else
                       raise Cosense::Error, 'Cosense::User.new need an argument :display_name or :displayName'
                     end

      @id = id
      @display_name = display_name
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
      { id:, name:, displayName: display_name, email: }
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
