# frozen_string_literal: true

require 'json'
require 'erubi'
require 'tilt'
require 'fileutils'

module Cosensee
  # generate HTML files
  class HtmlBuilder
    def initialize(project, output_dir: nil, css_dir: nil)
      @project = project
      @templates_dir = File.join(__dir__, '../../templates')
      @output_dir = output_dir || File.join(Dir.pwd, Cosensee::DEFAULT_OUTPUT_DIR)
      @css_dir = css_dir || Cosensee::DEFAULT_CSS_DIR
      FileUtils.mkdir_p(@output_dir)
    end

    attr_reader :project, :output_dir, :css_dir, :templates_dir

    def build_all(clean: true)
      purge_files if clean

      build_index(project)

      # build all pages
      project.pages.each do |page|
        build_page(page)
      end

      # build all orphan (title only) pages
      project.page_store.orphan_page_titles.each do |title|
        build_page_only_title(title)
      end
    end

    def build_index(project)
      render_html(src: 'index.html.erb', to: 'index.html', project:, css_dir:)
    end

    def build_page(page)
      render_html(src: 'page.html.erb', to: page.link_path, project:, css_dir:, page:, title: page.title)
    end

    def build_page_only_title(title)
      path = File.join(output_dir, "#{title.gsub(/ /, '_').gsub('/', '%2F')}.html")
      return if File.exist?(path)

      template = Tilt::ErubiTemplate.new(File.join(templates_dir, 'page.html.erb'), escape_html: true)
      output = template.render(nil, project:, page: nil, title:, css_dir:)
      File.write(path, output)
    end

    def purge_files
      FileUtils.rm_rf(Dir.glob("#{output_dir}/*.html"))
    end

    def render_html(src:, to:, **args)
      template = Tilt::ErubiTemplate.new(File.join(templates_dir, src), escape_html: true)
      output = template.render(nil, **args)
      File.write(File.join(output_dir, to), output)
    end
  end
end
