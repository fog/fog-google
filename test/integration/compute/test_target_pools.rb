require "helpers/integration_test_helper"
require "integration/factories/target_pools_factory"

class TestTargetPools < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].target_pools
    @factory = TargetPoolsFactory.new(namespaced_name)
  end

  # Override to include zone in get request
  def get_resource(identity)
    @subject.get(identity, TEST_ZONE)
  end
end
