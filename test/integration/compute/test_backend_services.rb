require "minitest_helper"
require "helpers/test_collection"
require "factories/backend_services_factory"

class TestBackendServices < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].backend_services
    @factory = BackendServicesFactory.new(namespaced_name)
  end
end
