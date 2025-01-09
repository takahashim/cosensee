# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::WebContentGenerator do
  let(:logger) { Console.logger }
  let(:sid) { 'valid_sid' }

  before do
    stub_const('DEFAULT_PORT', 1234)
    stub_const('DEFAULT_OUTPUT_DIR', 'dist')
  end

  describe '#generate' do
    let(:filename) { fixture_file('project.json') }
    let(:page_data) { instance_double(Cosensee::Api::PageData, download: '{"dummy":"data"}') }

    before do
      allow(Cosensee::Api::PageData).to receive(:new).and_return(page_data)
    end

    context 'when filename is missing' do
      it 'raises an error' do
        option = Cosensee::CLI::Option.new(filename: nil)
        generator = Cosensee::WebContentGenerator.new(option:, logger:, sid:)

        expect { generator.generate }.to raise_error(Cosensee::WebContentGenerator::Error, 'Filename is missing.')
      end
    end

    context 'when remote is true but SID is missing' do
      let(:sid) { nil }

      it 'raises an error' do
        option = Cosensee::CLI::Option.new(filename:, remote: 'example_project')
        generator = Cosensee::WebContentGenerator.new(option:, logger:, sid:)

        expect { generator.generate }.to raise_error(Cosensee::WebContentGenerator::Error, 'You must set CONNECT_SID as environment variable.')
      end
    end

    context 'when the specified file does not exist' do
      it 'raises an error' do
        option = Cosensee::CLI::Option.new(filename: 'not_exist.json')
        generator = Cosensee::WebContentGenerator.new(option:, logger:, sid:)

        expect { generator.generate }.to raise_error(Cosensee::WebContentGenerator::Error, 'File not found - not_exist.json')
      end
    end

    context 'when the file exists and remote is false' do
      let(:html_builder) { instance_double(Cosensee::HtmlBuilder, build_all: 'dummy') }
      let(:generator) do
        option = Cosensee::CLI::Option.new(filename:, skip_tailwind_execution: true)
        Cosensee::WebContentGenerator.new(option:, logger:, sid:)
      end

      before do
        allow(Cosensee::HtmlBuilder).to receive(:new).and_return(html_builder)
        allow(logger).to receive(:info)
      end

      it 'processes the file and generates HTML' do
        generator.generate
        expect(logger).to have_received(:info).with('Processing file: spec/fixtures/project.json').ordered
        expect(logger).to have_received(:info).with('Build all files into ./dist.').ordered
      end

      it 'calls HtmlBuilder to generate index and page files' do
        generator.generate
        expect(html_builder).to have_received(:build_all)
      end
    end

    context 'when remote is true and SID is valid' do
      let(:html_builder) { instance_double(Cosensee::HtmlBuilder) }
      let(:generator) do
        option = Cosensee::CLI::Option.new(filename:, remote: 'example_project', skip_tailwind_execution: true)

        Cosensee::WebContentGenerator.new(option:, logger:, sid:)
      end

      before do
        allow(Cosensee::HtmlBuilder).to receive(:new).and_return(html_builder)
        allow(html_builder).to receive(:build_all)
        allow(logger).to receive(:info)
      end

      it 'downloads with page-data API' do
        generator.generate

        expect(page_data).to have_received(:download)
      end

      it 'downloads the file and generates HTML' do
        generator.generate

        expect(logger).to have_received(:info).with('Retrieving file from remote API...').ordered
        expect(logger).to have_received(:info).with('File retrieved and saved as: spec/fixtures/project.json').ordered
        expect(logger).to have_received(:info).with('Processing file: spec/fixtures/project.json').ordered
        expect(logger).to have_received(:info).with('Build all files into ./dist.').ordered
      end

      it 'calls HtmlBuilder to generate index and page files' do
        generator.generate
        expect(html_builder).to have_received(:build_all)
      end
    end
  end
end
