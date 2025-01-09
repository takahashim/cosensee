# frozen_string_literal: true

require 'tailwindcss/ruby'

module Cosensee
  # build TailwindCSS Command, based on https://github.com/rails/tailwindcss-rails
  module TailwindCommand
    def self.compile_command(output_dir: Cosensee::DEFAULT_OUTPUT_DIR, css_dir: DEFAULT_CSS_DIR, debug: false, **)
      command = [
        Tailwindcss::Ruby.executable(**),
        '-i', File.join(__dir__, '../../assets/styles/input.css'),
        '-o', File.join(output_dir, css_dir, 'tailwind.css'),
        '-c', 'tailwind.config.js'
      ]

      command << '--minify' unless debug

      postcss_path = 'postcss.config.js'
      command += ['--postcss', postcss_path.to_s] if File.exist?(postcss_path)

      command
    end
  end
end
