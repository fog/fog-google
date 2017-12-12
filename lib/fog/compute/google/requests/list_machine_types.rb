module Fog
  module Compute
    class Google
      class Mock
        def list_machine_types(_zone, _opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_machine_types(zone, filter: nil, max_results: nil,
                               page_token: nil, order_by: nil)
          zone = zone.split("/")[-1] if zone.start_with? "http"
          @compute.list_machine_types(@project, zone,
                                      :filter => filter,
                                      :max_results => max_results,
                                      :page_token => page_token,
                                      :order_by => order_by)
        end
      end
    end
  end
end
