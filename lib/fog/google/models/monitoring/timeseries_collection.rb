require "fog/core/collection"
require "fog/google/models/monitoring/timeseries"

module Fog
  module Google
    class Monitoring
      class TimeseriesCollection < Fog::Collection
        model Fog::Google::Monitoring::Timeseries

        ##
        # Lists all Timeseries.
        #
        # @param [Hash] options Query parameters.
        # @option [String] filter  A monitoring filter that specifies which time series should be returned.
        #   The filter must specify a single metric type, and can additionally specify metric labels and other
        #   information.
        # @option options [Hash] interval Required. The time interval for which results should be returned.
        # @option interval [String] end_time Required RFC3339 timestamp marking the end of interval
        # @option interval [String] start_time Optional RFC3339 timestamp marking start of interval.
        # @option options [Hash] aggregation
        # @option aggregation [String] alignment_period
        # @option aggregation [String] cross_series_reducer
        # @option aggregation [String] group_by_fields
        # @option aggregation [String] per_series_aligner
        # @option options [String] order_by
        # @option options [String] page_size
        # @option options [String] page_token
        # @option options [String] view
        #
        # @return [Array<Fog::Google::Monitoring::Timeseries>] List of Timeseries.
        def all(options = {})
          data = service.list_timeseries(options).body["timeSeries"] || []
          load(data)
        end
      end
    end
  end
end
