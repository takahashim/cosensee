# frozen_string_literal: true

require 'json'

module Cosensee
  # for User
  User = Data.define(:id, :name, :display_name, :email) do
    def self.from_array(users_args)
      users_args.map do |args|
        if args.is_a?(Cosensee::User)
          args
        else
          new(**args)
        end
      end
    end

    # allow both `:display_key` and `:displayKey`
    def initialize(id:, name:, email:, **kwargs)
      display_name = if kwargs.keys == [:display_name]
                       kwargs[:display_name]
                     elsif kwargs.keys == [:displayName]
                       kwargs[:displayName]
                     else
                       raise Cosensee::Error, 'Cosensee::User.new need an argument :display_name or :displayName'
                     end
      super(
        id:,
        display_name:,
        name:,
        email:
      )
    end

    def to_obj
      { id:, name:, displayName: display_name, email: }
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
