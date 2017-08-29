module Fog
  module Compute
    class Google
      class Mock
        def get_target_https_proxy(_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_target_https_proxy(name)
          api_method = @compute.target_https_proxies.get
          parameters = {
            'project' => @project,
            'targetHttpsProxy' => name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
