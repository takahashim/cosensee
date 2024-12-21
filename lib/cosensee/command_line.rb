# frozen_string_literal: true

require 'json'

module Cosensee
  # for command line
  class CommandLine
    def initialize(content, prompt:)
      @content = content
      @prompt = prompt
    end

    attr_reader :content, :prompt

    def ==(other)
      if other.is_a?(Cosensee::CommandLine)
        other.content == content && other.prompt == prompt
      end
    end

    def to_obj
      "#{prompt} #{content}"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
