# frozen_string_literal: true

require_relative 'lib/cosensee/version'

Gem::Specification.new do |spec|
  spec.name = 'cosensee'
  spec.version = Cosensee::VERSION
  spec.authors = ['takahashim']
  spec.email = ['takahashimm@gmail.com']

  spec.summary = 'Cosense (Scrapbox) parser and renderer'
  spec.description = 'Cosensee is a tool that reads JSON data from Cosense (formerly Scrapbox) and outputs it in HTML format.'
  spec.homepage = 'https://github.com/takahashim/cosensee'
  spec.required_ruby_version = '>= 3.4.1'

  # spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/takahashim/cosensee'
  # spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'erubi'
  spec.add_dependency 'tilt'
  spec.add_dependency 'mini_mime'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
