require "minitest_helper"
require "helpers/test_collection"
require "factories/target_instances_factory"

class TestTargetInstances < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].target_instances
    @factory = TargetInstancesFactory.new(namespaced_name)
  end
end
