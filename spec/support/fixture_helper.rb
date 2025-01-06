# frozen_string_literal: true

module FixtureHelper
  def fixture_file(file_name)
    File.join('spec', 'fixtures', file_name)
  end

  def read_fixture_file(file_name)
    File.read(fixture_file(file_name))
  end
end
