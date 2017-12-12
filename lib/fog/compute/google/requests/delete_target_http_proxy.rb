module Fog
  module Compute
    class Google
      class Mock
        def delete_target_http_proxy(_proxy_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_target_http_proxy(proxy_name)
          @compute.delete_target_http_proxy(@project, proxy_name)
        end
      end
    end
  end
end
