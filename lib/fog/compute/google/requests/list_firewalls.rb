module Fog
  module Compute
    class Google
      class Mock
        def list_firewalls
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_firewalls(filter: nil, max_results: nil,
                           order_by: nil, page_token: nil)
          @compute.list_firewalls(@project,
                                  :filter => filter,
                                  :max_results => max_results,
                                  :order_by => order_by,
                                  :page_token => page_token)
        end
      end
    end
  end
end
