require "helpers/integration_test_helper"
require "integration/factories/firewalls_factory"

class TestFirewalls < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].firewalls
    @factory = FirewallsFactory.new(namespaced_name)
  end
end
