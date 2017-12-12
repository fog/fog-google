module Fog
  module Compute
    class Google
      class Mock
        def list_addresses(_region_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # List address resources in the specified project
        # https://cloud.google.com/compute/docs/reference/latest/addresses/list
        #
        # @param region_name [String] Region for address
        def list_addresses(region_name)
          @compute.list_addresses(@project, region_name)
        end
      end
    end
  end
end
