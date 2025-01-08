# frozen_string_literal: true

module Cosensee
  # convert project file to web content
  class WebContentGenerator
    class Error < StandardError; end

    attr_reader :option, :logger, :sid

    def initialize(option:, logger:, sid:)
      @option = option
      @logger = logger
      @sid = sid
    end

    def generate
      raise Error, 'Filename is missing.' unless filename

      download_page_data(sid) if option.remote?

      raise Error, "File not found - #{filename}" unless File.exist?(filename)

      logger.info "Processing file: #{filename}"
      project = Cosensee::Project.parse_file(filename)
      Cosensee::HtmlBuilder.new(project).build_all
      logger.info 'Build all files.'
    end

    private

    def filename
      option.filename
    end

    def project_name
      option.project_name
    end

    def download_page_data(sid)
      raise Error, 'You must set CONNECT_SID as environment variable.' unless sid

      logger.info 'Retrieving file from remote API...'
      Cosensee::Api::PageData.new.download(
        project_name:,
        sid:,
        filename:
      )
      logger.info "File retrieved and saved as: #{filename}"
    end
  end
end
