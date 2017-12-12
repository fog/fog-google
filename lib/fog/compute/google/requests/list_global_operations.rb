module Fog
  module Compute
    class Google
      class Mock
        def list_global_operations
          Fog::Mock.not_implemented
        end
      end

      class Real
        # @see https://developers.google.com/compute/docs/reference/latest/globalOperations/list
        def list_global_operations(filter: nil, max_results: nil,
                                   order_by: nil, page_token: nil)
          @compute.list_global_operations(
            @project,
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
