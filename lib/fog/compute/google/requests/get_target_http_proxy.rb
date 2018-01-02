module Fog
  module Compute
    class Google
      class Mock
        def get_target_http_proxy(_proxy_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_target_http_proxy(proxy_name)
          @compute.get_target_http_proxy(@project, proxy_name)
        end
      end
    end
  end
end
