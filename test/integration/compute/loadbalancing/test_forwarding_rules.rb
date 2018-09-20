require "helpers/integration_test_helper"
require "integration/factories/forwarding_rules_factory"

class TestForwardingRules < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.forwarding_rules
    @factory = ForwardingRulesFactory.new(namespaced_name)
  end
end
