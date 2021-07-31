require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "config/sequel"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :migrate do
  Sequel.extension :migration
  Sequel::Migrator.run DB, 'db/migrations'
end