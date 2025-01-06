# frozen_string_literal: true

require 'json'

module Cosensee
  module Node
    # for command line
    CommandLine = Data.define(:content, :prompt, :raw) do
      alias_method :to_s, :raw

      def to_obj
        "#{prompt} #{content}"
      end

      def to_json(*)
        to_obj.to_json(*)
      end
    end
  end
end
