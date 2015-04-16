require "minitest_helper"
require "helpers/test_collection"
require "factories/forwarding_rules_factory"

class TestForwardingRules < MiniTest::Test
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].forwarding_rules
    @factory = ForwardingRulesFactory.new
  end

  def teardown
    @factory.cleanup
  end
end
