# frozen_string_literal: true

require 'json'
# require 'uri'

module Cosensee
  # for Page
  Page = Data.define(:id, :title, :created, :updated, :views, :lines) do
    def self.from_array(args_list)
      args_list.map do |args|
        if args.is_a?(Cosensee::Page)
          args
        else
          new(**args)
        end
      end
    end

    def initialize(id:, title:, created:, updated:, views:, lines:)
      @parsed_lines = lines.drop(1).map { |arg| LineParser.parse(arg) }
      @linking_page_titles = @parsed_lines.map(&:internal_links).flatten
      @first_image = @parsed_lines.find(&:first_image)&.first_image

      super(
        id:,
        title:,
        created: Time.at(created),
        updated: Time.at(updated),
        views:,
        lines:
      )
    end

    attr_accessor :parsed_lines, :linking_page_titles, :first_image

    def summary
      if (image = first_image)
        if image.is_a?(Cosensee::Node::GyazoImageBracket)
          %(<img src="#{image.src}/raw" loading="lazy">)
        else
          %(<img src="#{image.src}" loading="lazy">)
        end
      else
        parsed_lines.map(&:to_s).take(MAX_SUMMARY_LINE).join
      end
    end

    def summary_text
      parsed_lines.map(&:to_s).join.slice(0, MAX_SUMMARY_TEXT_SIZE)
    end

    def song_page?
      parsed_lines.any?(&:song_tagged?)
    end

    def body_lines
      lines.drop(1)
    end

    def link_path
      # body = URI.encode_www_form_component(title.gsub(/ /, '_'))
      body = title.gsub(/ /, '_').gsub('=', '=3d').gsub('/', '=2F').gsub('#', '=23')

      "#{body}.html"
    end

    def to_html(project: nil)
      Cosensee::TailwindRenderer.new(content: self, project:).render
    end

    def to_obj
      { id:, title:, created: created.to_i, updated: updated.to_i, views:, lines: }
    end

    def to_json(*)
      to_obj.to_json(*)
    end

    def inspect
      "#<data Cosensee::Page id: #{id}, title: #{title}>"
    end
  end
end
