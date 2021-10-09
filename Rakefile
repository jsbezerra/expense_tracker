# frozen_string_literal: true

require "bundler/gem_tasks"
require "config/sequel"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new

task default: %i[rubocop spec]

task :migrate do
  Sequel.extension :migration
  Sequel::Migrator.run DB, "db/migrations"
end
