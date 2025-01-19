# frozen_string_literal: true

require 'uri'

module Cosensee
  # parser of Bracket
  module LinkEncodable
    def make_filename(anchor)
      "#{encode_filename(anchor)}.html"
    end

    def make_link(anchor)
      "#{encode_link(anchor)}.html"
    end

    # NG chars: `/#\?`
    # escape prefix char: `=`
    def encode_filename(str)
      str.gsub(/ /, '_').gsub('=', '=3d').gsub('/', '=2f').gsub('#', '=23').gsub('\\', '=5c').gsub('?', '=3f')
    end

    def encode_link(str)
      filename_encoded = encode_filename(str)
      URI.encode_www_form_component(filename_encoded)
    end
  end
end
