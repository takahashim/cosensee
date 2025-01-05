# frozen_string_literal: true

require 'json'
require 'erubi'
require 'tilt'
require 'fileutils'

module Cosensee
  # generate HTML files
  class HtmlBuilder
    def initialize(project, root_dir: nil)
      @project = project
      @templates_dir = File.join(__dir__, '../../templates')
      @root_dir = root_dir || File.join(Dir.pwd, '.out')
      FileUtils.mkdir_p(@root_dir)
    end

    attr_reader :project, :root_dir, :templates_dir

    def build_all
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
      template = Tilt::ErubiTemplate.new(File.join(templates_dir, 'index.html.erb'))
      output = template.render(nil, project:)
      File.write(File.join(root_dir, 'index.html'), output)
    end

    def build_page(page)
      template = Tilt::ErubiTemplate.new(File.join(templates_dir, 'page.html.erb'))
      output = template.render(nil, project:, page:, title: page.title)
      File.write(File.join(root_dir, page.link_path), output)
    end

    def build_page_only_title(title)
      template = Tilt::ErubiTemplate.new(File.join(templates_dir, 'page.html.erb'))
      output = template.render(nil, project:, page: nil, title:)
      path = File.join(root_dir, "#{title.gsub(/ /, '_').gsub('/', '%2F')}.html")
      unless File.exist?(path)
        File.write(path, output)
      end
    end

    def page_title(page)
      "#{page.title} | #{project.title}"
    end
  end
end
