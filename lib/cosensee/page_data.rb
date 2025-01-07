# frozen_string_literal: true

require 'open-uri'

module Cosensee
  # for page-data API
  class PageData
    def export(project_name:, sid:)
      uri = "https://scrapbox.io/api/page-data/export/#{project_name}.json"
      send_request(uri, sid)
    end

    def download(project_name:, sid:, filename:)
      res = export(project_name:, sid:)

      File.binwrite(filename, res)
    end

    private

    def send_request(uri, sid)
      cookies = "connect.sid=#{sid}"
      parsed_uri = URI.parse(uri)
      response = parsed_uri.open('Cookie' => cookies)
      response.read
    end
  end
end
