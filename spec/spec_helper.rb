ENV['RACK_ENV'] = 'test'

require 'simplecov'

SimpleCov.start

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

  config.order = :random

  config.warnings = true

  config.profile_examples = 10

  config.filter_gems_from_backtrace 'rack', 'rack-test', 'sequel', 'sinatra'
end
