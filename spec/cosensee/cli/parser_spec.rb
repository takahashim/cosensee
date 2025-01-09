# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::CLI::Parser do
  before do
    stub_const('DEFAULT_PORT', 3030)
    stub_const('DEFAULT_OUTPUT_DIR', 'default_dir')
  end

  describe '.parse' do
    context 'when all required options are provided' do
      it 'parses -f option correctly' do
        args = ['-f', 'test_file']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.filename).to eq('test_file')
        expect(result.failed?).to be false
      end

      it 'parses -r option correctly' do
        args = ['-f', 'test_file', '-r', 'project_name']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.remote?).to be true
        expect(result.project_name).to eq('project_name')
        expect(result.failed?).to be false
      end

      it 'parses -p option correctly' do
        args = ['-s', '-p', '8080']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.port).to eq('8080')
        expect(result.failed?).to be false
      end

      it 'parses -d option correctly' do
        args = ['-d', 'output_dir', '-f', 'test_file']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.dir).to eq('output_dir')
        expect(result.failed?).to be false
      end

      it 'parses -s option correctly' do
        args = ['-s']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.server?).to be true
        expect(result.failed?).to be false
      end
    end

    context 'when missing required options' do
      it 'returns an error when filename is missing without -s' do
        args = []
        expect { Cosensee::CLI::Parser.parse(args) }.to output(/Error: filename not found/).to_stdout
      end

      it 'returns an error when -r is used without -f' do
        args = ['-r', 'project_name']
        expect { Cosensee::CLI::Parser.parse(args) }.to output(/Error: filename not found./).to_stdout
      end
    end

    context 'when invalid options are provided' do
      it 'handles missing argument for an option' do
        args = ['-f']
        expect { Cosensee::CLI::Parser.parse(args) }.to output(/Error: option requires an argument/).to_stdout
      end
    end
  end
end
