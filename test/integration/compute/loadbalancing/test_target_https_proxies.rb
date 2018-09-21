require "helpers/integration_test_helper"
require "integration/factories/target_https_proxies_factory"

class TestTargetHttpsProxies < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].target_https_proxies
    @factory = TargetHttpsProxiesFactory.new(namespaced_name)
  end
end
