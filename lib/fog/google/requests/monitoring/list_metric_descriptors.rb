module Fog
  module Google
    class Monitoring
      ##
      # List metric descriptors that match the query. If the query is not set, then all of the metric descriptors
      # will be returned.
      #
      # @see https://cloud.google.com/monitoring/v2beta2/metricDescriptors/list
      class Real
        def list_metric_descriptors(options = {})
          @monitoring.list_metric_descriptors(@project,
                                              nil,
                                              :count => options[:count],
                                              :page_token => options[:page_token],
                                              :query => options[:query])
        end
      end

      class Mock
        def list_metric_descriptors(_options = {})
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
