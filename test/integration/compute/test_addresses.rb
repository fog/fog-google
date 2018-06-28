require "helpers/integration_test_helper"
require "integration/factories/addresses_factory"

class TestAddresses < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].addresses
    @factory = AddressesFactory.new(namespaced_name)
  end
end
