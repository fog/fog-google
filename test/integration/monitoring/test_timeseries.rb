require "helpers/integration_test_helper"
require "retriable"

class TestMetricDescriptors < FogIntegrationTest
  # Retriable is used to wrap each request in this test due to Stackdriver API being slow with
  # metric propagation (sometimes 80+ seconds) and client returning
  # Google::Apis::ClientError: badRequest if the metric hasn't yet been created instead of a 404.
  RETRIABLE_TRIES = 3
  RETRIABLE_BASE_INTERVAL = 50
  TEST_METRIC_PREFIX = "custom.googleapis.com/fog-google-test/timeseries".freeze
  LABEL_DESCRIPTORS = [
    {
      :key => "test_string_label",
      :value_type => "STRING",
      :description => "test string label"
    },
    {
      :key => "test_bool_label",
      :value_type => "BOOL",
      :description => "test boolean label"
    },
    {
      :key => "test_int_label",
      :value_type => "INT64",
      :description => "test integer label"
    }
  ].freeze

  def setup
    @client = Fog::Google::Monitoring.new
    # Ensure any resources we create with test prefixes are removed

    Minitest.after_run do
      _delete_test_resources
    end
  end

  def test_timeseries_collection
    metric_type = "#{TEST_METRIC_PREFIX}/test_requests"
    _some_custom_metric_descriptor(metric_type)

    start_time = Time.now
    labels = {
      :test_string_label => "foo",
      :test_bool_label => "false",
      :test_int_label => "1"
    }

    expected = _some_timeseries(start_time, metric_type, labels)
    resp = @client.create_timeseries(:timeseries => [expected])
    assert_empty(resp.to_h)

    # Wait for metric to be created
    # TODO: Dedup retries into a helper method
    Retriable.retriable(on: Google::Apis::ClientError,
                        tries: RETRIABLE_TRIES,
                        base_interval: RETRIABLE_BASE_INTERVAL) do
      @client.list_timeseries(
          :filter => "metric.type = \"#{metric_type}\"",
          :interval => {
            # Subtracting one second because timeSeries.list API
            # doesn't return points that are exactly the same time
            # as the interval for some reason.
            :start_time => (start_time - 1).to_datetime.rfc3339,
            :end_time => Time.now.to_datetime.rfc3339
          }
      ).time_series
    end

    series = Retriable.retriable(on: Google::Apis::ClientError,
                                 tries: RETRIABLE_TRIES,
                                 base_interval: RETRIABLE_BASE_INTERVAL) do
      @client.timeseries_collection.all(
        :filter => "metric.type = \"#{metric_type}\"",
        :interval => {
          # Subtracting one second because timeSeries.list API
          # doesn't return points that are exactly the same time
          # as the interval for some reason.
          :start_time => (start_time - 1).to_datetime.rfc3339,
          :end_time => Time.now.to_datetime.rfc3339
        }
      )
    end

    assert_equal(1, series.size)
    actual = series.first
    assert_equal(expected[:metric], actual.metric)
    assert_equal(expected[:metric_kind], actual.metric_kind)

    assert_equal(expected[:resource], actual.resource)
    assert_equal(expected[:value_type], actual.value_type)
    assert_equal(1, actual.points.size)
    assert_equal(expected[:points].first[:value], actual.points.first[:value])
  end

  def test_multiple_timeseries
    metric_type = "#{TEST_METRIC_PREFIX}/test_multiple"
    _some_custom_metric_descriptor(metric_type)

    start_time = Time.now
    metric_labels = [
      {
        :test_string_label => "first",
        :test_bool_label => "true",
        :test_int_label => "1"
      },
      {
        :test_string_label => "second",
        :test_bool_label => "false",
        :test_int_label => "2"
      }
    ]

    timeseries = metric_labels.map do |labels|
      _some_timeseries(start_time, metric_type, labels)
    end

    Retriable.retriable(on: Google::Apis::ServerError,
                        tries: RETRIABLE_TRIES,
                        base_interval: RETRIABLE_BASE_INTERVAL) do
      @client.create_timeseries(:timeseries => timeseries)
    end
    interval = {
      # Subtracting one second because timeSeries.list API
      # doesn't return points that are exactly the same time
      # as the interval for some reason.
      :start_time => (start_time - 1).to_datetime.rfc3339,
      :end_time => Time.now.to_datetime.rfc3339
    }


    # Wait for metric to be created
    # Retriable is used instead of wait_for due to API client returning Google::Apis::ClientError: badRequest if the
    # metric hasn't yet been created
    Retriable.retriable(on: Google::Apis::ClientError,
                        tries: RETRIABLE_TRIES,
                        base_interval: RETRIABLE_BASE_INTERVAL) do
      @client.list_timeseries(
        :filter => "metric.type = \"#{metric_type}\"",
        :interval => interval
      ).time_series
    end

    # Test page size
    resp = Retriable.retriable(on: Google::Apis::ClientError,
                               tries: RETRIABLE_TRIES,
                               base_interval: RETRIABLE_BASE_INTERVAL) do
      @client.list_timeseries(
        :filter => "metric.type = \"#{metric_type}\"",
        :interval => interval,
        :page_size => 1
      )
    end
    assert_equal(resp.time_series.size, 1,
                 "expected timeseries count to be equal to page size 1")

    next_resp = @client.list_timeseries(
      :filter => "metric.type = \"#{metric_type}\"",
      :interval => interval,
      :page_size => 1,
      :page_token => resp.next_page_token
    )
    assert_equal(next_resp.time_series.size, 1,
                 "expected timeseries count to be equal to page size 1")
    labels = resp.time_series.first.metric.labels
    labels_next = next_resp.time_series.first.metric.labels
    assert(labels != labels_next,
           "expected different timeseries when using page_token")

    # Test filter
    series = Retriable.retriable(on: Google::Apis::ClientError,
                                 tries: RETRIABLE_TRIES,
                                 base_interval: RETRIABLE_BASE_INTERVAL) do
      @client.timeseries_collection.all(
        :filter => %[
          metric.type = "#{metric_type}" AND
          metric.label.test_string_label = "first"
        ],
        :interval => interval
      )
    end
    assert_equal(series.size, 1,
                 "expected returned timeseries to be filtered to 1 value")
    assert_equal("true", series.first.metric[:labels][:test_bool_label])
    assert_equal("1", series.first.metric[:labels][:test_int_label])
  end

  def _delete_test_resources
    list_resp = @client.monitoring.list_project_metric_descriptors(
      "projects/#{@client.project}",
      filter: "metric.type = starts_with(\"#{TEST_METRIC_PREFIX}\")"
    )
    unless list_resp.metric_descriptors.nil?
      list_resp.metric_descriptors.each do |md|
        @client.monitoring.delete_project_metric_descriptor(md.name)
      end
    end
  rescue
    # Do nothing
  end

  def _some_custom_metric_descriptor(metric_type)
    # Create custom metric to write test timeseries for.
    @client.create_metric_descriptor(
      :labels => LABEL_DESCRIPTORS,
      :metric_type => metric_type,
      :unit => "1",
      :value_type => "INT64",
      :description => "A custom metric descriptor for fog-google timeseries test.",
      :display_name => "fog-google-test/#{metric_type}",
      :metric_kind => "GAUGE"
    )

    # Wait for metric descriptor to be created
    Fog.wait_for(180, 2) do
      begin
        @client.get_metric_descriptor(metric_type)
        true
      rescue
        false
      end
    end
  end

  def _some_timeseries(start_time, metric_type, labels)
    {
      :metric => {
        :type => metric_type,
        :labels => labels
      },
      :resource => {
        :type => "global",
        :labels => { :project_id => @client.project }
      },
      :metric_kind => "GAUGE",
      :value_type => "INT64",
      :points => [
        {
          :interval => {
            :end_time => start_time.to_datetime.rfc3339,
            :start_time => start_time.to_datetime.rfc3339
          },
          :value => {
            :int64_value => rand(10)
          }
        }
      ]
    }
  end
end
