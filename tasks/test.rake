require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = File.join("test", "**", "test_*.rb")
  t.warning = false
end

Rake::TestTask.new do |t|
  t.name = "compute"
  t.libs << "test"
  t.pattern = File.join("test", "**", "test_*.rb")
  t.warning = false
end

namespace :test do
  mock = ENV["FOG_MOCK"] || "true"
  task :travis do
    sh("export FOG_MOCK=#{mock} && bundle exec shindont")
  end

  Rake::TestTask.new do |t|
    t.name = "compute"
    t.libs << "test"
    t.pattern = FileList['test/integration/compute/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "monitoring"
    t.libs << "test"
    t.pattern = FileList['test/integration/monitoring/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "pubsub"
    t.libs << "test"
    t.pattern = FileList['test/integration/monitoring/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "pubsub"
    t.libs << "test"
    t.pattern = FileList['test/integration/pubsub/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "sql"
    t.libs << "test"
    t.pattern = FileList['test/integration/sql/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "storage"
    t.libs << "test"
    t.pattern = FileList['test/integration/storage/test_*.rb']
    t.warning = false
    t.verbose = true
  end
end
