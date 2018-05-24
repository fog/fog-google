require "rake/testtask"

Rake::TestTask.new do |t|
  t.description = "Run integration and unit tests"
  t.libs << "test"
  t.pattern = File.join("test", "**", "test_*.rb")
  t.warning = false
end

namespace :test do
  mock = ENV["FOG_MOCK"] || "true"
  task :travis do
    sh("bundle exec rake test:unit")
  end

  desc "Run all integration tests in parallel"
  multitask :parallel => ["test:compute",
                          "test:monitoring",
                          "test:pubsub",
                          "test:sqlv1",
                          "test:sqlv2",
                          "test:storage"]

  Rake::TestTask.new do |t|
    t.name = "unit"
    t.description = "Run Unit tests"
    t.libs << "test"
    t.pattern = FileList['test/unit/**/test_*.rb']
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "compute"
    t.description = "Run Compute API tests"
    t.libs << "test"
    t.pattern = FileList["test/integration/compute/test_*.rb"]
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "monitoring"
    t.description = "Run Monitoring API tests"
    t.libs << "test"
    t.pattern = FileList["test/integration/monitoring/test_*.rb"]
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "pubsub"
    t.description = "Run PubSub API tests"
    t.libs << "test"
    t.pattern = FileList["test/integration/pubsub/test_*.rb"]
    t.warning = false
    t.verbose = true
  end

  desc "Run all SQL API tests in parallel"
  multitask :sql_parallel => [:sqlv1, :sqlv2]

  desc "Run all SQL API tests"
  task :sql => [:sqlv1, :sqlv2]

  Rake::TestTask.new do |t|
    t.name = "sqlv1"
    t.description = "Run SQLv1 API tests"
    t.libs << "test"
    t.pattern = FileList["test/integration/sql/test_common*.rb","test/integration/sql/test_v1*.rb"]
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "sqlv2"
    t.description = "Run SQLv2 API tests"
    t.libs << "test"
    t.pattern = FileList["test/integration/sql/test_v2*.rb"]
    t.warning = false
    t.verbose = true
  end

  Rake::TestTask.new do |t|
    t.name = "storage"
    t.description = "Run Storage API tests"
    t.libs << "test"
    t.pattern = FileList["test/integration/storage/test_*.rb"]
    t.warning = false
    t.verbose = true
  end
end
