module Fog
  module Compute
    class Google
      class Mock
        def list_http_health_checks
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_http_health_checks(filter: nil, max_results: nil,
                                    order_by: nil, page_token: nil)
          @compute.list_http_health_checks(
            @project,
            :filter => filter, :max_results => max_results,
            :order_by => order_by, :page_token => page_token
          )
        end
      end
    end
  end
end
