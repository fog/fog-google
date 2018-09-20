require "helpers/integration_test_helper"
require "integration/factories/firewalls_factory"

class TestFirewalls < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.firewalls
    @factory = FirewallsFactory.new(namespaced_name)
  end
end
