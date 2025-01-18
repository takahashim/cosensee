# frozen_string_literal: true

module Cosensee
  class CLI
    # Option class for Cosensee::CLI
    class Option
      attr_accessor :port, :output_dir, :css_dir
      attr_writer :failed, :server, :remote, :filename, :skip_tailwind_execution, :init, :clean

      def initialize(filename: nil, remote: nil, port: DEFAULT_PORT, output_dir: DEFAULT_OUTPUT_DIR, css_dir: DEFAULT_CSS_DIR, server: nil, skip_tailwind_execution: false, init: nil, clean: false)
        @remote = remote
        @filename = filename
        @port = port
        @output_dir = output_dir
        @css_dir = css_dir
        @server = server
        @skip_tailwind_execution = skip_tailwind_execution
        @failed = false
        @clean = clean
        @init = init
      end

      def filename
        @filename || ENV['COSENSEE_FILENAME']
      end

      def project_name
        @remote || ENV['COSENSEE_PROJECT_NAME']
      end

      def project_dir
        @init || '.'
      end

      def remote?
        !!@remote
      end

      def failed?
        @failed
      end

      def server?
        @server
      end

      def skip_tailwind_execution?
        @skip_tailwind_execution
      end

      def clean?
        @clean
      end

      def init?
        !!@init
      end
    end
  end
end
