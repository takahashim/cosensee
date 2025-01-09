# frozen_string_literal: true

module Cosensee
  # for CLI
  class CLI
    # for initializer
    class Initializer
      def initialize(logger:, option:)
        @logger = logger
        @option = option
      end

      attr_reader :logger, :option

      def run
        logger.info 'Initializing...'
        create_project_dir if option.init?
        create_directories
        create_files
        logger.info 'Done!'
      end

      private

      def create_project_dir
        return if File.exist?(project_path)

        FileUtils.mkdir_p(project_path)
        logger.info "Created project directory: #{project_path}"
      end

      def create_directories
        FileUtils.mkdir_p(project_path(option.output_dir))
        FileUtils.mkdir_p(project_path(option.output_dir, option.css_dir))
      end

      def create_files
        create_tailwind_config
      end

      def create_tailwind_config
        return if File.exist?(Cosensee::TAILWIND_CONFIG_FILE)

        logger.info 'Creating TailwindCSS config file...'
        File.write(Cosensee::TAILWIND_CONFIG_FILE, <<~TAILWIND_CONFIG)
          /** @type {import('tailwindcss').Config} */
          module.exports = {
            content: [
              "dist/**/*.html"
            ],
            theme: {
              extend: {},
            },
            plugins: [],
          }
        TAILWIND_CONFIG
      end

      def project_path(*relative_paths)
        File.join(option.project_dir, *relative_paths)
      end
    end
  end
end
