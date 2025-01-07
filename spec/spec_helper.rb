# frozen_string_literal: true

require 'cosensee'
require 'rspec-parameterized'
require 'factory_bot'
require_relative 'support/fixture_helper'
require_relative 'support/time_helper'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.max_formatted_output_length = 1000
  end

  config.include FixtureHelper
  config.include TimeHelper
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.definition_file_paths = ['spec/factories']
FactoryBot.find_definitions
