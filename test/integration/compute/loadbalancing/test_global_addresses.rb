require "helpers/integration_test_helper"
require "integration/factories/global_addresses_factory"

class TestGlobalAddresses < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.global_addresses
    @factory = GlobalAddressesFactory.new(namespaced_name)
  end
end
