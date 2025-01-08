require "tailwindcss/ruby"

module Cosensee
  # build TailwindCSS Command, based on https://github.com/rails/tailwindcss-rails
  module TailwindCommand
    def self.compile_command(debug: false, **kwargs)
      command = [
        Tailwindcss::Ruby.executable(**kwargs),
        "-i", "assets/styles/input.css",
        "-o", "public/styles/tailwind.css",
        "-c", "tailwind.config.js"
      ]

      command << "--minify" unless debug

      postcss_path = "postcss.config.js"
      command += ["--postcss", postcss_path.to_s] if File.exist?(postcss_path)

      command
    end
  end
end
