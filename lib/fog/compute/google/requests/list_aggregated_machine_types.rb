module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_machine_types(_opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_aggregated_machine_types(filter: nil, max_results: nil,
                                          page_token: nil, order_by: nil)
          @compute.list_aggregated_machine_types(
            @project,
            :filter => filter, :max_results => max_results,
            :page_token => page_token, :order_by => order_by
          )
        end
      end
    end
  end
end
