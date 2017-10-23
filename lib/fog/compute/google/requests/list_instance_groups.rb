module Fog
  module Compute
    class Google
      class Mock
        def list_instance_groups(_zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_instance_groups(zone)
          @compute.list_instance_groups(@project, zone)
        end
      end
    end
  end
end
