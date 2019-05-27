module Fog
  module Google
    class Compute
      class Mock
        def delete_backend_service(_backend_service_name, _zone_name = nil)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_backend_service(backend_service_name)
          @compute.delete_backend_service(@project, backend_service_name)
        end
      end
    end
  end
end
