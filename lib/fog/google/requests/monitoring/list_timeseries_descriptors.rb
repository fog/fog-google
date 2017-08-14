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
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
