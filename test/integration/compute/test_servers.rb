require "helpers/integration_test_helper"
require "integration/factories/servers_factory"

class TestServers < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].servers
    @factory = ServersFactory.new(namespaced_name)
  end
end
