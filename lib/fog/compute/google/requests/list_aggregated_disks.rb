module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_disks(options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        # Retrieves an aggregated list of disks
        # https://cloud.google.com/compute/docs/reference/latest/disks/aggregatedList
        #
        # @param options [Hash] Optional hash of options
        # @option options [String] :filter Filter expression for filtering listed resources
        def list_aggregated_disks(options = {})
          @compute.list_aggregated_disk(@project, :filter => options[:filter])
        end
      end
    end
  end
end
