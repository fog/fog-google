require "minitest_helper"
require "helpers/test_collection"
require "factories/forwarding_rules_factory"

class TestForwardingRules < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].forwarding_rules
    @factory = ForwardingRulesFactory.new(namespaced_name)
  end

  def teardown
    @factory.cleanup
  end
end
