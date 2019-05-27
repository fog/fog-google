module Fog
  module Google
    class Compute
      class Mock
        def list_addresses(_region_name, _opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        # List address resources in the specified project
        # @see https://cloud.google.com/compute/docs/reference/latest/addresses/list
        def list_addresses(region_name, filter: nil, max_results: nil,
                           order_by: nil, page_token: nil)
          @compute.list_addresses(
            @project, region_name,
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          )
        end
      end
    end
  end
end
