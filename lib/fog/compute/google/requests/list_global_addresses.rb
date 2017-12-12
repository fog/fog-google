module Fog
  module Compute
    class Google
      class Mock
        def list_global_addresses(_opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        # List address resources in the specified project
        # @see https://cloud.google.com/compute/docs/reference/latest/globalAddresses
        def list_global_addresses(filter: nil, max_results: nil, order_by: nil,
                                  page_token: nil)
          @compute.list_global_addresses(@project,
                                         :filter => filter,
                                         :max_results => max_results,
                                         :order_by => order_by,
                                         :page_token => page_token)
        end
      end
    end
  end
end
