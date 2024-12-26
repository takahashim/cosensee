# frozen_string_literal: true

require 'json'

module Cosensee
  # for command line
  CommandLine = Data.define(:content, :prompt) do
    def to_obj
      "#{prompt} #{content}"
    end

    def to_json(*)
      to_obj.to_json(*)
    end
  end
end
