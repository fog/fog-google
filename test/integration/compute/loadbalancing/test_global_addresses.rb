require "helpers/integration_test_helper"
require "integration/factories/global_addresses_factory"

class TestGlobalAddresses < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].global_addresses
    @factory = GlobalAddressesFactory.new(namespaced_name)
  end
end
