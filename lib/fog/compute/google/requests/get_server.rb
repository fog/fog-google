module Fog
  module Compute
    class Google
      class Mock
        def get_server(_instance, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_server(instance, zone)
          @compute.get_instance(@project, zone.split("/")[-1], instance)
        end
      end
    end
  end
end
