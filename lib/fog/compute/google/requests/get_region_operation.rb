module Fog
  module Compute
    class Google
      class Mock
        def get_region_operation(region_name, operation)
          raise Fog::Errors::MockNotImplemented
        end
      end

      class Real
        # Get the updated status of a region operation
        # https://developers.google.com/compute/docs/reference/latest/regionOperations
        #
        # @param region_name [String] Region for address
        # @param operation [Google::Apis::ComputeV1::Operation] Return value from asynchronous actions
        def get_region_operation(region_name, operation)
          if region_name.start_with? "http"
            region_name = region_name.split("/")[-1]
          end
          @compute.get_region_operation(@project, region_name, operation)
        end
      end
    end
  end
end
