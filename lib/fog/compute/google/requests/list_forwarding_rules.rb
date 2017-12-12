module Fog
  module Compute
    class Google
      class Mock
        def list_forwarding_rules(_region, _opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_forwarding_rules(region,
                                  filter: nil, max_results: nil,
                                  order_by: nil, page_token: nil)
          @compute.list_forwarding_rules(
            @project, region,
            :filter => filter, :max_results => max_results,
            :order_by => order_by, :page_token => page_token
          )
        end
      end
    end
  end
end
