module Fog
  module Compute
    class Google
      class Mock
        def suspend_server(_identity, _zone)
          # :no-coverage:
          Fog::Mock.not_implemented
          # :no-coverage:
        end
      end

      class Real
        def suspend_server(identity, zone, discard_local_ssd=false)
          @compute.suspend_instance(@project, zone.split("/")[-1], identity, discard_local_ssd: discard_local_ssd)
        end
      end
    end
  end
end
