# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::CLI::Parser do
  before do
    stub_const('DEFAULT_PORT', 3030)
    stub_const('DEFAULT_OUTPUT_DIR', 'default_dir')
    stub_const('DEFAULT_CSS_DIR', 'css_dir')
  end

  describe '.parse' do
    context 'when valid options are provided' do
      it 'parses -f option correctly' do
        args = ['-f', 'test_file']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.filename).to eq('test_file')
        expect(result.failed?).to be false
      end

      it 'parses --css-dir option correctly' do
        args = ['-f', 'test_file', '--css-dir', 'custom_css_dir']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.filename).to eq('test_file')
        expect(result.css_dir).to eq('custom_css_dir')
        expect(result.failed?).to be false
      end

      it 'parses --skip-tailwind option correctly' do
        args = ['-f', 'test_file', '--skip-tailwind']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.filename).to eq('test_file')
        expect(result.skip_tailwind_execution?).to be true
        expect(result.failed?).to be false
      end

      it 'parses --init option correctly' do
        args = ['--init', 'new_project']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.init?).to be true
        expect(result.project_dir).to eq('new_project')
        expect(result.failed?).to be false
      end

      it 'handles a combination of options' do
        args = ['-f', 'test_file', '--css-dir', 'custom_css_dir', '--skip-tailwind']
        result = Cosensee::CLI::Parser.parse(args)

        expect(result.filename).to eq('test_file')
        expect(result.css_dir).to eq('custom_css_dir')
        expect(result.skip_tailwind_execution?).to be true
        expect(result.failed?).to be false
      end
    end

    context 'when missing required arguments' do
      it 'returns an error when --init is missing a project directory' do
        args = ['--init']
        expect { Cosensee::CLI::Parser.parse(args) }.to output(/Error: option requires an argument: --init/).to_stdout
      end

      it 'returns an error when --css-dir is missing a value' do
        args = ['--css-dir']
        expect { Cosensee::CLI::Parser.parse(args) }.to output(/Error: option requires an argument: --css-dir/).to_stdout
      end
    end

    context 'when invalid options are provided' do
      it 'handles unknown option gracefully' do
        args = ['--unknown']
        expect { Cosensee::CLI::Parser.parse(args) }.to output(/invalid option: --unknown/).to_stdout
      end
    end
  end
end
