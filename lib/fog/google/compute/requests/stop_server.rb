module Fog
  module Google
    class Compute
      class Mock
        def stop_server(_identity, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def stop_server(identity, zone)
          @compute.stop_instance(@project, zone.split("/")[-1], identity)
        end
      end
    end
  end
end
