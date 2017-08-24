module Fog
  module Compute
    class Google
      class Mock
        def delete_target_https_proxy(name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_target_https_proxy(name)
          api_method = @compute.target_https_proxies.delete
          parameters = {
            "project" => @project,
            "targetHttpsProxy" => name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
