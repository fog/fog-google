module Fog
  module Compute
    class Google
      class Mock
        def delete_server(_server, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_server(server, zone)
          @compute.delete_instance(@project, zone.split("/")[-1], server)
        end
      end
    end
  end
end
