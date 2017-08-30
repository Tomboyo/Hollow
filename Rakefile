require "bundler/gem_tasks"
require "rake/testtask"

ENV['gem_push']  = 'off'

Rake::TestTask.new do |task|
  task.test_files = FileList['test/spec/**/*.rb']
  task.verbose = true
end

task :default => :spec
