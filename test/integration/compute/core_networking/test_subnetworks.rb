require "helpers/integration_test_helper"
require "integration/factories/subnetworks_factory"

class TestSubnetworks < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.subnetworks
    @factory = SubnetworksFactory.new(namespaced_name)
  end
end
