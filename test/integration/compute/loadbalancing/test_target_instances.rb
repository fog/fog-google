require "helpers/integration_test_helper"
require "integration/factories/target_instances_factory"

class TestTargetInstances < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.target_instances
    @factory = TargetInstancesFactory.new(namespaced_name)
  end
end
