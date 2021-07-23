require "helpers/integration_test_helper"
require "integration/factories/networks_factory"
require "integration/factories/servers_factory"

class TestNetworks < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].networks
    @servers = ServersFactory.new(namespaced_name)
    @factory = NetworksFactory.new(namespaced_name)
  end

  def teardown
    # Clean up the server resources used in testing
    @servers.cleanup
    super
  end

  def test_run_instance
    network = @factory.create
    server = @servers.create(:network_interfaces => [network.get_as_interface_config])

    assert_equal(
      network.self_link,
      server.network_interfaces[0][:network],
      "Created server should have the network specified on boot"
    )
  end
end
