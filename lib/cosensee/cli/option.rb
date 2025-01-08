module Cosensee
  class CLI
    # Option class for Cosensee::CLI
    class Option
      attr_accessor :port, :dir
      attr_writer :failed, :server, :remote, :filename

      def initialize(filename: nil, remote: nil, port: DEFAULT_PORT, dir: DEFAULT_DIR, server: nil)
        @remote = !!remote
        @filename = filename
        @port = port
        @dir = dir
        @server = server
        @failed = false
      end

      def filename
        @filename || ENV['COSENSEE_FILENAME']
      end

      def project_name
        @remote || ENV['COSENSEE_PROJECT_NAME']
      end

      def remote?
        @remote
      end

      def failed?
        @failed
      end

      def server?
        @server
      end
    end
  end
end
