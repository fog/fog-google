require 'bundler/gem_tasks'
require 'rake/testtask'
require 'fog/google'

Rake::TestTask.new do |t|
  t.libs.push %w(spec)
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

desc 'Default Task'
task :default => [ :test, 'test:travis' ]

namespace :test do
  mock = ENV['FOG_MOCK'] || 'true'
  task :travis do
    sh("export FOG_MOCK=#{mock} && bundle exec shindont")
  end
end

namespace :google do
  namespace :smoke do
    desc "Smoke tests for Google Compute Engine."
    task :compute do
      puts "These smoke tests assume you have a file at ~/.fog which has your credentials for connecting to GCE."

      Dir.glob("./examples/*.rb").each do |file|
        puts "Running #{file}:"
        require file
        test
      end
    end
  end
end
