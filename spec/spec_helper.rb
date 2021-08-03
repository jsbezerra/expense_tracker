ENV['RACK_ENV'] = 'test'

require 'simplecov'

SimpleCov.start do
  enable_coverage :branch
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Configure the test syntax to use rspec
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Enable RSpec commands to be used without prefixing them with 'Rspec.'
  config.expose_dsl_globally = true

  # Enable the aggregation of failures everywhere unless it has been explicitly disabled
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end

  config.when_first_matching_example_defined(:db) do
    require 'support/db'
  end

  # Enable random ordering when running the tests
  config.order = :random

  # Enable warnings
  config.warnings = true

  # Enable profiling
  config.profile_examples = 10

  config.filter_gems_from_backtrace 'rack', 'rack-test', 'sequel', 'sinatra'
end
