# frozen_string_literal: true

require 'open-uri'

module Cosensee
  module Api
    # for page-data API
    class PageData
      def export(project_name:, sid:)
        uri = "https://scrapbox.io/api/page-data/export/#{project_name}.json"
        send_request(uri, sid)
      end

      def download(project_name:, sid:, filename:)
        res = export(project_name:, sid:)

        begin
          File.binwrite(filename, res)
        rescue SystemCallError => e
          raise Cosensee::Error, "Failed to write to file '#{filename}': #{e.message}"
        end
      end

      private

      def send_request(uri, sid)
        cookies = "connect.sid=#{sid}"
        parsed_uri = URI.parse(uri)

        begin
          response = parsed_uri.open('Cookie' => cookies)
          response.read
        rescue OpenURI::HTTPError => e
          raise Cosensee::Error, "HTTP error while accessing #{uri}: #{e.message}"
        rescue SocketError => e
          raise Cosensee::Error, "Network error: #{e.message}"
        rescue URI::InvalidURIError => e
          raise Cosensee::Error, "Invalid URI: #{e.message}"
        end
      end
    end
  end
end
