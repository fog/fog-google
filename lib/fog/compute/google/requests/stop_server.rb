module Fog
  module Compute
    class Google
      class Mock
        def stop_server(_identity, _zone)
          # :no-coverage:
          Fog::Mock.not_implemented
          # :no-coverage:
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
