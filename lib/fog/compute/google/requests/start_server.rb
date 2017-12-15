module Fog
  module Compute
    class Google
      class Mock
        def start_server(_identity, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def start_server(identity, zone)
          @compute.start_instance(@project, zone.split("/")[-1], identity)
        end
      end
    end
  end
end
