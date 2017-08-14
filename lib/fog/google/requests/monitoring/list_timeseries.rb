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
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
