module Fog
  module Compute
    class Google
      class Mock
        def list_url_maps(_filter: nil, _max_results: nil,
                          _order_by: nil, _page_token: nil)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_url_maps(filter: nil, max_results: nil,
                          order_by: nil, page_token: nil)
          @compute.list_url_maps(
            @project,
            :filter => filter, :max_results => max_results,
            :order_by => order_by, :page_token => page_token
          )
        end
      end
    end
  end
end
