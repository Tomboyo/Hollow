require "bundler/gem_tasks"
require "rake/testtask"

ENV['gem_push']  = 'off'

desc "Test lib"
task :test_lib do
  Rake::TestTask.new(:task) do |task|
    task.test_files = FileList['test/spec/**/*.rb']
    task.verbose = true
  end
  Rake::Task[:task].invoke
end

desc "Test examples"
task :test_examples do
  Rake::TestTask.new(:task) do |task|
    task.test_files = FileList['examples/*/spec/**/*.rb']
    task.verbose = true
  end
  Rake::Task[:task].invoke
end

task :test_all => [:test_lib, :test_examples]
