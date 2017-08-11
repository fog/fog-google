module Fog
  module Google
    class Monitoring
      ##
      # List the descriptors of the time series that match the metric and labels values and that have data points
      # in the interval.
      #
      # @see https://developers.google.com/cloud-monitoring/v2beta1/timeseriesDescriptors/list
      class Real
        def list_timeseries_descriptors(metric, youngest, options = {})
          @monitoring.list_timeseries_descriptors(@project,
                                                  metric,
                                                  youngest,
                                                  nil,
                                                  nil,
                                                  options[:count],
                                                  options[:labels],
                                                  options[:oldest],
                                                  options[:page_token],
                                                  options[:timespan])
        end
      end

      class Mock
        def list_timeseries_descriptors(metric, youngest, _options = {})
          body = {
            "kind" => 'cloudmonitoring#listTimeseriesDescriptorsResponse',
            "youngest" => youngest,
            "oldest" => youngest,
            "timeseries" => [
              {
                "project" => @project,
                "metric" => metric,
                "labels" => {
                  "cloud.googleapis.com/service" => "compute.googleapis.com",
                  "compute.googleapis.com/resource_type" => "instance",
                  "cloud.googleapis.com/location" => "us-central1-a",
                  "compute.googleapis.com/resource_id" => Fog::Mock.random_numbers(20).to_s,
                  "compute.googleapis.com/instance_name" => Fog::Mock.random_hex(40)
                }
              },
              {
                "project" => @project,
                "metric" => metric,
                "labels" => {
                  "cloud.googleapis.com/service" => "compute.googleapis.com",
                  "compute.googleapis.com/resource_type" => "instance",
                  "cloud.googleapis.com/location" => "us-central1-a",
                  "compute.googleapis.com/resource_id" => Fog::Mock.random_numbers(20).to_s,
                  "compute.googleapis.com/instance_name" => Fog::Mock.random_hex(40)
                }
              },
              {
                "project" => @project,
                "metric" => metric,
                "labels" => {
                  "cloud.googleapis.com/service" => "compute.googleapis.com",
                  "compute.googleapis.com/resource_type" => "instance",
                  "cloud.googleapis.com/location" => "us-central1-a",
                  "compute.googleapis.com/resource_id" => Fog::Mock.random_numbers(20).to_s,
                  "compute.googleapis.com/instance_name" => Fog::Mock.random_hex(40)
                }
              },
              {
                "project" => @project,
                "metric" => metric,
                "labels" => {
                  "cloud.googleapis.com/service" => "compute.googleapis.com",
                  "compute.googleapis.com/resource_type" => "instance",
                  "cloud.googleapis.com/location" => "us-central1-a",
                  "compute.googleapis.com/resource_id" => Fog::Mock.random_numbers(20).to_s,
                  "compute.googleapis.com/instance_name" => Fog::Mock.random_hex(40)
                }
              }
            ]
          }

          build_excon_response(body)
        end
      end
    end
  end
end
