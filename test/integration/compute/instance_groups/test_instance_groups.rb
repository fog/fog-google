require "helpers/integration_test_helper"
require "integration/factories/instance_groups_factory"

class TestInstanceGroups < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.instance_groups
    @factory = InstanceGroupsFactory.new(namespaced_name)
  end
end
