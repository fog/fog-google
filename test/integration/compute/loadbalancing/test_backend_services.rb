require "helpers/integration_test_helper"
require "integration/factories/backend_services_factory"

class TestBackendServices < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.backend_services
    @factory = BackendServicesFactory.new(namespaced_name)
  end
end
