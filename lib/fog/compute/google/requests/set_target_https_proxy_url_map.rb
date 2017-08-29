module Fog
  module Compute
    class Google
      class Mock
        def set_target_https_proxy_url_map(_target_https_proxy, _url_map)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_target_https_proxy_url_map(target_https_proxy, url_map)
          api_method = @compute.target_https_proxies.set_url_map
          parameters = {
            "project" => @project,
            "targetHttpsProxy" => target_https_proxy.name
          }
          url_map = url_map.self_link unless url_map.class == String
          body = {
            "urlMap" => url_map
          }

          request(api_method, parameters, body)
        end
      end
    end
  end
end
