require "fog/core/collection"
require "fog/google/models/monitoring/metric_descriptor"

module Fog
  module Google
    class Monitoring
      class MetricDescriptors < Fog::Collection
        model Fog::Google::Monitoring::MetricDescriptor

        ##
        # Lists all Metric Descriptors.
        #
        # @param [Hash] options Optional query parameters.
        # @option options [String] page_size Maximum number of metric descriptors per page. Used for pagination.
        # @option options [String] page_token The pagination token, which is used to page through large result sets.
        # @option options [String] filter Monitoring filter specifying which metric descriptors are to be returned.
        # @see https://cloud.google.com/monitoring/api/v3/filters filter documentation
        # @return [Array<Fog::Google::Monitoring::MetricDescriptor>] List of Metric Descriptors.
        def all(options = {})
          data = service.list_metric_descriptors(options).body["metricDescriptors"] || []
          load(data)
        end
      end
    end
  end
end
