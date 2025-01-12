# frozen_string_literal: true

module Cosensee
  # Add `delegate` method that delegate method calls to another object
  #
  # Usage:
  #
  # ```ruby
  # class Foo
  #   extend Delegatable
  #
  #   def initialize(bar)
  #     @bar = bar
  #   end
  #
  #   attr_reader :bar
  #
  #   delegate :buz, :baz, to: :bar
  # end
  # ```
  #
  #  This will define `buz` and `baz` method that call `bar.buz` and `bar.baz` respectively.
  module Delegatable
    def delegate(*methods, to:)
      methods.each do |method|
        define_method(method) do |*args, **kargs, &block|
          target = send(to)
          target.public_send(method, *args, **kargs, &block)
        end
      end
    end
  end
end
