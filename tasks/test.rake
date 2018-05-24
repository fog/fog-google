require "rake/testtask"

Rake::TestTask.new do |t|
  t.description = "Run all integration tests"
  t.libs << "test"
  t.pattern = File.join("test", "**", "test_*.rb")
  t.warning = false
end

namespace :test do
  mock = ENV["FOG_MOCK"] || "true"
  task :travis do
    sh("export FOG_MOCK=#{mock} && bundle exec shindont")
  end

  desc "Run all integration tests in parallel"
  multitask :parallel => ["test:compute",
                          "test:monitoring",
                          "test:pubsub",
                          "test:sql",
                          "test:storage"]
  Rake::TestTask.new do |t|
    t.name = "compute"
    t.description = "Run Compute API tests"
    t.libs << "test"
    t.pattern = FileList['test/integration/compute/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "monitoring"
    t.description = "Run Monitoring API tests"
    t.libs << "test"
    t.pattern = FileList['test/integration/monitoring/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "pubsub"
    t.description = "Run PubSub API tests"
    t.libs << "test"
    t.pattern = FileList['test/integration/pubsub/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "sql"
    t.description = "Run SQL API tests"
    t.libs << "test"
    t.pattern = FileList['test/integration/sql/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "storage"
    t.description = "Run Storage API tests"
    t.libs << "test"
    t.pattern = FileList['test/integration/storage/test_*.rb']
    t.warning = false
    t.verbose = true
  end
end
