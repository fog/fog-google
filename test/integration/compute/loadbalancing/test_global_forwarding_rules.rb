require "helpers/integration_test_helper"
require "integration/factories/global_forwarding_rules_factory"

class TestGlobalForwardingRules < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.global_forwarding_rules
    @factory = GlobalForwardingRulesFactory.new(namespaced_name)
  end
end
