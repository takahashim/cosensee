# frozen_string_literal: true

require 'uri'

module Cosensee
  # parser of Bracket
  module LinkEncodable
    UNESCAPED_REGEX = /[A-Za-z0-9!"\$&'\(\)\-\~@+;:*<>,._]/

    def make_link(anchor)
      "#{encode_link(anchor)}.html"
    end

    def encode_link(str)
      str.chars.map do |char|
        if char.match?(UNESCAPED_REGEX)
          char
        elsif char == ' '
          '_'
        else
          URI.encode_www_form_component(char)
        end
      end.join
    end
  end
end
