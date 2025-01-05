# frozen_string_literal: true

require 'cgi/util'

module Cosensee
  # parser of Bracket
  module HtmlEncodable
    def escape_html(str)
      CGI.escape_html(str)
    end
  end
end
