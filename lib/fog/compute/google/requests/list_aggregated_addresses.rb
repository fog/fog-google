module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_addresses(_options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        # Retrieves an aggregated list of addresses
        # https://cloud.google.com/compute/docs/reference/latest/addresses/aggregatedList
        # @param options [Hash] Optional hash of options
        # @option options [String] :filter Filter expression for filtering listed resources
        def list_aggregated_addresses(options = {})
          @compute.list_aggregated_addresses(@project, :filter => options[:filter])
        end
      end
    end
  end
end
