module Fog
  module Compute
    class Google
      class Mock
        def insert_target_https_proxy(_name, _options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_target_https_proxy(name, opts = {})
          api_method = @compute.target_https_proxies.insert
          parameters = {
            "project" => @project
          }
          body_object = { "name" => name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
