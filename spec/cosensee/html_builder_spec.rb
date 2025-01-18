# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'
require 'tmpdir'

RSpec.describe Cosensee::HtmlBuilder do
  let(:first_page) { build(:page, title: 'page1') }
  let(:second_page) { build(:page, title: 'page2', lines: ['line1', 'line2', '[Orphan1][Orphan2]']) }
  let(:project) { build(:project, pages: [first_page, second_page]) }
  let(:output_dir) { Dir.mktmpdir }
  let(:css_dir) { 'css' }
  let(:templates_dir) { File.expand_path('../../templates', __dir__) }

  before do
    stub_const('Cosensee::DEFAULT_OUTPUT_DIR', 'output')
    stub_const('Cosensee::DEFAULT_CSS_DIR', 'css')
  end

  after do
    FileUtils.remove_entry(output_dir)
  end

  describe '#initialize' do
    it 'initializes with correct attributes' do
      builder = Cosensee::HtmlBuilder.new(project, output_dir:, css_dir:)
      absolute_templates_dir = File.expand_path(builder.templates_dir)
      expect(builder.project).to eq(project)
      expect(builder.output_dir).to eq(output_dir)
      expect(builder.css_dir).to eq(css_dir)
      expect(absolute_templates_dir).to eq(templates_dir)
    end
  end

  describe '#build_all' do
    it 'builds all HTML files' do
      builder = Cosensee::HtmlBuilder.new(project, output_dir:, css_dir:)

      builder.build_all

      expect(File).to exist(File.join(output_dir, 'index.html'))
      expect(File.read(File.join(output_dir, 'index.html'))).to include('Sample Project')

      project.pages.each do |page|
        expect(File).to exist(File.join(output_dir, page.link_path))
        expect(File.read(File.join(output_dir, page.link_path))).to include(page.title)
      end

      project.orphan_page_titles.each do |title|
        orphan_path = File.join(output_dir, "#{title.gsub(/ /, '_').gsub('/', '%2F')}.html")
        expect(File).to exist(orphan_path)
        expect(File.read(orphan_path)).to include(title)
      end
    end
  end

  describe '#purge_files' do
    it 'removes all HTML files in the output directory' do
      builder = Cosensee::HtmlBuilder.new(project, output_dir:, css_dir:)
      FileUtils.touch(File.join(output_dir, 'test.html'))
      expect(File).to exist(File.join(output_dir, 'test.html'))

      builder.purge_files

      expect(Dir.glob("#{output_dir}/*.html")).to be_empty
    end
  end

  describe '#build_index' do
    it 'creates the index.html file' do
      builder = Cosensee::HtmlBuilder.new(project, output_dir:, css_dir:)

      builder.build_index(project)

      expect(File).to exist(File.join(output_dir, 'index.html'))

      content = File.read(File.join(output_dir, 'index.html'))
      expect(content).to include('Sample Project')
      expect(content).to include('page1')
    end
  end

  describe '#build_page' do
    let(:first_page) { build(:page, title: 'Test Page', lines: ['test', '  code:test.rb', '  a = b', '  c = d', 'e = f']) }

    it 'creates an HTML file for a given page' do
      builder = Cosensee::HtmlBuilder.new(project, output_dir:, css_dir:)

      builder.build_page(first_page)

      expect(File).to exist(File.join(output_dir, 'Test_Page.html'))
      content = File.read(File.join(output_dir, 'Test_Page.html'))
      expect(content).to include('Test Page')
      expect(content).to include('test.rb')
      expect(content).to include('a = b')
      expect(content).to include('c = d')
      expect(content).to include('e = f')
    end
  end

  describe '#build_page_only_title' do
    it 'creates an HTML file for a page with only a title' do
      builder = Cosensee::HtmlBuilder.new(project, output_dir:, css_dir:)
      title = 'Only Title'

      builder.build_page_only_title(title)

      file_path = File.join(output_dir, 'Only_Title.html')
      expect(File).to exist(file_path)
      expect(File.read(file_path)).to include('Only Title')
    end
  end
end
