require "minitest_helper"
require "helpers/test_collection"
require "factories/target_pools_factory"

class TestTargetPools < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].target_pools
    @factory = TargetPoolsFactory.new(namespaced_name)
  end

  def teardown
    @factory.cleanup
  end
end
