require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = File.join("test", "**", "test_*.rb")
  t.warning = false
end

namespace :test do
  mock = ENV["FOG_MOCK"] || "true"
  task :travis do
    sh("export FOG_MOCK=#{mock} && bundle exec shindont")
  end
end
