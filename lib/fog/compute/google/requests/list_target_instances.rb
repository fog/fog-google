module Fog
  module Compute
    class Google
      class Mock
        def list_target_instances(_zone, _opts: {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_target_instances(zone, filter: nil, max_results: nil,
                                  order_by: nil, page_token: nil)
          zone = zone.split("/")[-1] if zone.start_with? "http"
          @compute.list_target_instances(
            @project, zone,
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
