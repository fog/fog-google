module Fog
  module Compute
    class Google
      class Mock
        def list_target_https_proxies
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_target_https_proxies
          api_method = @compute.target_https_proxies.list
          parameters = {
            "project" => @project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
