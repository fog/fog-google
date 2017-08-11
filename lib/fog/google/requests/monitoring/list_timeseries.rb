module Fog
  module Google
    class Monitoring
      ##
      # List the data points of the time series that match the metric and labels values and that have data points
      # in the interval
      #
      # https://developers.google.com/cloud-monitoring/v2beta1/timeseries
      class Real
        def list_timeseries(metric, youngest, options = {})
          @monitoring.list_timeseries(@project,
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
        def list_timeseries(metric, youngest, _options = {})
          body = {
            "kind" => 'cloudmonitoring#listTimeseriesResponse',
            "youngest" => youngest,
            "oldest" => youngest,
            "timeseries" => [
              {
                "timeseriesDesc" => {
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
                "points" => [
                  {
                    "start" => "2014-07-17T20:06:58.000Z",
                    "end" => "2014-07-17T20:07:58.000Z",
                    "doubleValue" => 60.0
                  },
                  {
                    "start" => "2014-07-17T20:05:58.000Z",
                    "end" => "2014-07-17T20:06:58.000Z",
                    "doubleValue" => 60.0
                  }
                ]
              }
            ]
          }

          build_excon_response(body)
        end
      end
    end
  end
end
