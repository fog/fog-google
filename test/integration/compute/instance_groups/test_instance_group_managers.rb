require "helpers/integration_test_helper"
require "integration/factories/instance_group_manager_factory"

class TestInstanceGroupManagers < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].instance_group_managers
    @factory = InstanceGroupManagerFactory.new(namespaced_name)
  end
end
