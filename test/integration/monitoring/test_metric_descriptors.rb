require "helpers/integration_test_helper"
require "helpers/client_helper"

class TestMetricDescriptors < FogIntegrationTest
  TEST_METRIC_TYPE_PREFIX = "custom.googleapis.com/fog-google-test/test-metric-descriptors".freeze

  def setup
    @client = Fog::Google::Monitoring.new
    # Ensure any resources we create with test prefixes are removed
    Minitest.after_run do
      delete_test_resources
    end
  end

  def delete_test_resources
    test_resources = @client.monitoring.list_project_metric_descriptors(
      "projects/#{@project}",
      :filter => "metric.type = starts_with(\"#{TEST_METRIC_TYPE_PREFIX}\")"
    )
    unless test_resources.metric_descriptors.nil?
      test_resources.metric_descriptors.each do |md|
        @client.monitoring.delete_project_metric_descriptors(md.name)
      end
    end
  rescue
    # Do nothing
  end

  def test_list_metric_descriptors
    list_resp = @client.list_metric_descriptors
    assert_operator(list_resp.metric_descriptors.size, :>, 0,
                    "metric descriptor count should be positive")

    resp = @client.list_metric_descriptors(
      :filter => 'metric.type = starts_with("compute.googleapis.com")',
      :page_size => 5
    )
    assert_operator(resp.metric_descriptors.size, :<=, 5,
                    "metric descriptor count should be <= page size 5")

    resp = @client.list_metric_descriptors(:page_size => 1)
    assert_equal(resp.metric_descriptors.size, 1,
                 "metric descriptor count should be page size 1")

    next_resp = @client.list_metric_descriptors(
      :page_size => 1,
      :page_token => resp.next_page_token
    )
    assert_equal(next_resp.metric_descriptors.size, 1, "metric descriptor count should be page size 1")
    assert(resp.metric_descriptors[0].name != next_resp.metric_descriptors[0].name,
           "paginated result should not be the same value")
  end

  def test_create_custom_metric_descriptors
    metric_type = "#{TEST_METRIC_TYPE_PREFIX}/test-create"
    label = {
      :key => "foo",
      :value_type => "INT64",
      :description => "test label for a metric descriptor"
    }
    options = {
      :metric_type => metric_type,
      :unit => "1",
      :value_type => "INT64",
      :description => "A custom metric descriptor for fog-google metric descriptor tests.",
      :display_name => "fog-google/test-metric-descriptor",
      :metric_kind => "GAUGE",
      :labels => [label]
    }

    created = @client.create_metric_descriptor(**options)

    # Check created metric descriptor
    assert_equal(_full_name(metric_type), created.name)
    assert_equal(metric_type, created.type)
    assert_equal(options[:metric_kind], created.metric_kind)
    assert_equal(options[:value_type], created.value_type)
    assert_equal(options[:unit], created.unit)
    assert_equal(options[:description], created.description)
    assert_equal(options[:display_name], created.display_name)

    assert_equal(created.labels.size, 1, "expected 1 label, got #{created.labels.size}")
    label_descriptor = created.labels.first
    assert_equal(label[:key], label_descriptor.key)
    assert_equal(label[:value_type], label_descriptor.value_type)
    assert_equal(label[:description], label_descriptor.description)

    Fog.wait_for(30) do
      begin
        get_resp = @client.get_metric_descriptor(metric_type)
        return !get_resp.nil?
      rescue
        return false
      end
    end

    list_resp = @client.list_metric_descriptor(:filter => "metric.type = \"#{metric_type}\"", :page_size => 1)
    assert(!list_resp.metric_descriptors.nil?, "expected non-empty list request for metric descriptors")

    assert_empty(@client.delete_metric_descriptor(metric_type))
  end

  def test_metric_descriptors_all
    descriptors = @client.metric_descriptors.all
    assert_operator(descriptors.size, :>, 0,
                    "metric descriptor count should be positive")
  end

  def test_metric_descriptors_all_page_size
    descriptors = @client.metric_descriptors.all(
      :filter => 'metric.type = starts_with("compute.googleapis.com")',
      :page_size => 5
    )
    assert_operator(descriptors.size, :<=, 5,
                    "metric descriptor count should be <= page size 5")

    descriptors = @client.metric_descriptors.all(:page_size => 2)
    assert_equal(descriptors.size, 2, "metric descriptor count should be page size 2")
  end

  def test_metric_descriptors_get
    builtin_test_type = "compute.googleapis.com/instance/cpu/usage_time"

    descriptor = @client.metric_descriptors.get("compute.googleapis.com/instance/cpu/usage_time")
    assert_equal(descriptor.type, builtin_test_type)
  end

  def _full_name(metric_type)
    "projects/#{@client.project}/metricDescriptors/#{metric_type}"
  end
end
