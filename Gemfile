# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in cosensee.gemspec
gemspec

group :test, :development do
  gem 'rake'
  gem 'rubocop'
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false

  gem "falcon"
end

group :test do
  gem 'rspec'
  gem 'rspec-parameterized'
end
