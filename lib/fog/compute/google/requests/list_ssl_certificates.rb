module Fog
  module Compute
    class Google
      class Mock
        def list_ssl_certificates()
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_ssl_certificates()
          api_method = @compute.ssl_certificates.list
          parameters = {
            "project" => @project
          }
          request(api_method, parameters)
        end
      end
    end
  end
end
