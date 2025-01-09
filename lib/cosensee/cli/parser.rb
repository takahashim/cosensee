# frozen_string_literal: true

require 'optparse'

module Cosensee
  class CLI
    # Parser class for Cosensee::CLI
    class Parser
      attr_reader :args, :option, :op

      def self.parse(args)
        new(args).parse
      end

      def initialize(args)
        @args = args
        @option = Option.new
        @op = OptionParser.new
      end

      def parse
        begin
          op.banner = 'Usage: bin/build [-f <filename>] [-r <project_name>]'

          op.on('-f FILENAME', '--file FILENAME', 'Specify the file name') do |filename|
            option.filename = filename
          end
          op.on('-r PROJECT_NAME', '--remote PROJECT_NAME', 'Retrieve the project pages file from the remote page-data API') do |project_name|
            option.remote = project_name
          end
          op.on('-p PORT', '--port PORT', "Specify port number of web server (default: #{DEFAULT_PORT})") do |port|
            option.port = port
          end
          op.on('-d OUTPUT_DIR', '--dir OUTPUT_DIR', "Specify directory name of generated html files(default: #{DEFAULT_OUTPUT_DIR})") do |output_dir|
            option.output_dir = output_dir
          end
          op.on('-s', '--server', 'Serves files by running a web server locally.') do
            option.server = true
          end

          op.on('--skip-tailwind', 'Skip TailwindCSS execution') do
            option.skip_tailwind_execution = true
          end

          op.parse!(args)
        rescue OptionParser::MissingArgument => e
          return option_error("Error: option requires an argument: #{e.args.join(' ')}")
        end

        if !option.filename && !option.server?
          return option_error('Error: filename not found. You must specify -f, or use server with -s.')
        elsif !option.filename && option.remote?
          return option_error('Error: project_name not found. You must not specify project name -p without -f.')
        end

        option
      end

      private

      def option_error(message)
        puts message
        puts op.help
        option.failed = true
        option
      end
    end
  end
end
