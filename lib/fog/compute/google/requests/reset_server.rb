module Fog
  module Compute
    class Google
      class Mock
        def reset_server(_identity, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def reset_server(identity, zone)
          @compute.reset_instance(@project, zone.split("/")[-1], identity)
        end
      end
    end
  end
end
