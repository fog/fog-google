require "helpers/integration_test_helper"
require "integration/factories/subnetworks_factory"

class TestSubnetworks < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].subnetworks
    @factory = SubnetworksFactory.new(namespaced_name)
  end
end
