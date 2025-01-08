# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in cosensee.gemspec
gemspec

group :test, :development do
  gem 'irb'
  gem 'rake'
  gem 'rubocop'
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'rspec'
  gem 'rspec-parameterized'

  gem 'factory_bot'
end
