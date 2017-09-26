require "fog/core/collection"
require "fog/google/models/monitoring/monitored_resource_descriptor"

module Fog
  module Google
    class Monitoring
      class MonitoredResourceDescriptors < Fog::Collection
        model Fog::Google::Monitoring::MonitoredResourceDescriptor

        ##
        # Lists all Monitored Resource Descriptors.
        #
        # @param [Hash] options Optional query parameters.
        # @option options [String] page_size Maximum number of metric descriptors per page. Used for pagination.
        # @option options [String] page_token The pagination token, which is used to page through large result sets.
        # @option options [String] filter The monitoring filter used to search against existing descriptors.
        #   See
        # @return [Array<Fog::Google::Monitoring::MetricDescriptor>] List of Monitored Resource Descriptors.
        def all(options = {})
          data = service.list_monitored_resource_descriptors(options).body["resourceDescriptors"] || []
          load(data)
        end
      end
    end
  end
end
