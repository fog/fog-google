require "helpers/integration_test_helper"
require "integration/factories/url_maps_factory"

class TestUrlMaps < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.url_maps
    @factory = UrlMapsFactory.new(namespaced_name)
  end
end
