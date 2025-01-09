# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::CLI::Initializer do
  let(:logger) { instance_double(Logger) }
  let(:option) do
    Cosensee::CLI::Option.new(
      output_dir: 'output',
      css_dir: 'css',
      init:
    )
  end
  let(:init) { 'dummy_path' }
  let(:initializer) { Cosensee::CLI::Initializer.new(logger:, option:) }

  before do
    allow(logger).to receive(:info)
    allow(FileUtils).to receive(:mkdir_p)
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:write)
  end

  describe '#run' do
    it 'logs initialization process and creates directories and files' do
      initializer.run

      expect(logger).to have_received(:info).with('Initializing...')
      expect(logger).to have_received(:info).with('Done!')
    end

    context 'when init is defined' do
      it 'creates the project directory' do
        initializer.run

        expect(FileUtils).to have_received(:mkdir_p).with('dummy_path')
        expect(logger).to have_received(:info).with('Created project directory: dummy_path')
      end
    end

    context 'when init is `.``' do
      let(:init) { '.' }

      it 'creates the project directory' do
        initializer.run

        expect(FileUtils).to have_received(:mkdir_p).with('.')
        expect(logger).to have_received(:info).with('Created project directory: .')
      end
    end

    context 'when init is false' do
      let(:init) { nil }

      it 'does not create the project directory' do
        initializer.run

        expect(FileUtils).not_to have_received(:mkdir_p).with('.')
        expect(logger).not_to have_received(:info).with('Created project directory: .')
      end
    end
  end

  describe '#create_directories' do
    it 'creates output and css directories' do
      initializer.send(:create_directories)

      expect(FileUtils).to have_received(:mkdir_p).with('dummy_path/output')
      expect(FileUtils).to have_received(:mkdir_p).with('dummy_path/output/css')
    end
  end

  describe '#create_files' do
    it 'creates TailwindCSS config file if it does not exist' do
      initializer.send(:create_files)

      expect(logger).to have_received(:info).with('Creating TailwindCSS config file...')
      expect(File).to have_received(:write).with(
        Cosensee::TAILWIND_CONFIG_FILE,
        /tailwindcss/
      )
    end

    it 'does not create TailwindCSS config file if it exists' do
      allow(File).to receive(:exist?).with(Cosensee::TAILWIND_CONFIG_FILE).and_return(true)

      initializer.send(:create_files)

      expect(logger).not_to have_received(:info).with('Creating TailwindCSS config file...')
      expect(File).not_to have_received(:write)
    end
  end
end
