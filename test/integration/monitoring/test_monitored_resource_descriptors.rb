require "helpers/integration_test_helper"

class TestMetricDescriptors < FogIntegrationTest
  def setup
    @client = Fog::Google::Monitoring.new
  end

  def test_list_and_get
    resp = @client.list_monitored_resource_descriptors

    assert_operator(resp.resource_descriptors.size, :>, 0,
                    "resource descriptor count should be positive")

    @client.get_monitored_resource_descriptor(
      resp.resource_descriptors.first.type
    )
  end

  def test_all
    resp = @client.monitored_resource_descriptors.all

    assert_operator(resp.size, :>, 0,
                    "resource descriptor count should be positive")
  end

  def test_get
    resource = "global"
    descriptor = @client.monitored_resource_descriptors.get(resource)

    assert_equal(
      descriptor.name,
      "projects/#{@client.project}/monitoredResourceDescriptors/#{resource}"
    )
    assert_equal(descriptor.labels.size, 1)
    assert_equal(descriptor.labels.first[:key], "project_id")
  end
end
