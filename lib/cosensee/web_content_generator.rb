# frozen_string_literal: true

module Cosensee
  # convert project file to web content
  class WebContentGenerator
    class Error < StandardError; end

    SEARCH_DATA_PATH = 'search.json'

    attr_reader :option, :logger, :sid, :skip_tailwind_execution

    def initialize(option:, logger:, sid:)
      @option = option
      @logger = logger
      @sid = sid
      @skip_tailwind_execution = option.skip_tailwind_execution?
    end

    def generate
      raise Error, 'Filename is missing.' unless filename

      download_page_data(sid) if option.remote?

      raise Error, "File not found - #{filename}" unless File.exist?(filename)

      logger.info "Processing file: #{filename}"
      project = Cosensee::Project.parse_file(filename)
      Cosensee::HtmlBuilder.new(project, output_dir: option.output_dir).build_all
      logger.info "Build all files into #{option.output_dir}."

      copy_js_files

      execute_tailwind unless skip_tailwind_execution

      dump_search_data(project)
    end

    def execute_tailwind
      FileUtils.mkdir_p(File.join(option.output_dir, option.css_dir))
      command = Cosensee::TailwindCommand.compile_command(output_dir: option.output_dir, css_dir: option.css_dir, debug: false)
      logger.info "Processing TailwindCSS: #{command.inspect}"
      system(*command, exception: true)
    end

    def dump_search_data(project)
      data = project.dump_search_data
      File.write(File.join(option.output_dir, SEARCH_DATA_PATH), data.to_json)
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

    def copy_js_files
      FileUtils.mkdir_p(File.join(option.output_dir, 'js'))
      Dir.glob("#{__dir__}/../../assets/js/*.js") do |path|
        js_file = File.basename(path)
        FileUtils.cp(path, File.join(option.output_dir, 'js', js_file))
      end
    end
  end
end
