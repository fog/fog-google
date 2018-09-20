require "helpers/integration_test_helper"
require "integration/factories/disks_factory"

class TestDisks < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.disks
    @factory = DisksFactory.new(namespaced_name)
  end
end
