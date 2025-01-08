# frozen_string_literal: true

require 'mini_mime'
require 'uri'

module Cosensee
  class WebServer
    # Rack application for Falcon that serves static files from a directory.
    class StaticFileHandler
      def initialize(dir:, logger:)
        @dir = dir
        @logger = logger
      end

      attr_reader :dir, :logger

      def call(env)
        path_info = env['PATH_INFO']
        logger.info("Request path: #{env['PATH_INFO']}")
        path_info = if path_info.start_with?('/')
                      "/#{URI.decode_www_form_component(path_info.slice(1..-1))}"
                    else
                      URI.decode_www_form_component(path_info)
                    end
        path = File.join(dir, path_info)
        path = File.join(path, 'index.html') if File.directory?(path)

        if File.exist?(path) && !File.directory?(path)
          content = File.read(path)
          content_type = MiniMime.lookup_by_filename(path).content_type
          content_length = content.bytesize.to_s

          logger.info("Response size: #{content_length}")

          [200, { 'Content-Type' => content_type, 'Content-Length' => content_length }, [content]]
        else
          logger.info("Error File not found path: #{env['PATH_INFO']}")
          [404, { 'Content-Type' => 'text/plain' }, ["File not found: #{env['PATH_INFO']}"]]
        end
      end
    end
  end
end
