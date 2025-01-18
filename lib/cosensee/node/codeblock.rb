# frozen_string_literal: true

require 'json'

module Cosensee
  module Node
    # for codeblock
    Codeblock = Data.define(:content, :name, :raw) do
      alias_method :to_s, :raw

      # @param [String] text
      # @param [String] raw_line
      # @return [Codeblock]
      def append_text(text:, raw_line:)
        new_content = if content && !content.empty?
                        "#{content}\n#{text}"
                      else
                        text
                      end
        Codeblock.new(content: new_content, name:, raw: "#{raw}\n#{raw_line}")
      end

      def to_obj
        "code:#{content}"
      end

      def to_json(*)
        to_obj.to_json(*)
      end
    end
  end
end
