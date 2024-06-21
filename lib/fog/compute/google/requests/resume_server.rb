module Fog
  module Compute
    class Google
      class Mock
        def resume_server(_identity, _zone)
          # :no-coverage:
          Fog::Mock.not_implemented
          # :no-coverage:
        end
      end

      class Real
        def suspend_server(identity, zone)
          @compute.resume_instance(@project, zone.split("/")[-1], identity)
        end
      end
    end
  end
end
