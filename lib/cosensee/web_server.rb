# frozen_string_literal: true

require 'async'
require 'async/http/endpoint'
require 'falcon'

module Cosensee
  # Web server for serving static files
  class WebServer
    def initialize(dir:, server_url:, logger:)
      @dir = dir
      @server_url = server_url
      @logger = logger

      endpoint = Async::HTTP::Endpoint.parse(server_url)
      handler = StaticFileHandler.new(dir:, logger:)
      app = Falcon::Server.middleware(handler)
      @server = Falcon::Server.new(app, endpoint)
    end

    def start
      Async do |task|
        @logger.info("Serving files from #{File.expand_path(@dir)} at #{@server_url}")

        Signal.trap('INT') do
          @logger.info("\nShutting down the server...")
          task.stop
        end

        @server.run
      end
    rescue Interrupt
      @logger.warn("\nServer interrupted. Exiting.")
    ensure
      @logger.info('Cleanup complete.')
    end
  end
end
