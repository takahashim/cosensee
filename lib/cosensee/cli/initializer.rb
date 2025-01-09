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
        create_directories
        create_files
        logger.info 'Done!'
      end

      private

      def create_directories
        FileUtils.mkdir_p(option.output_dir)
        FileUtils.mkdir_p(File.join(option.output_dir, option.css_dir))
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
    end
  end
end
