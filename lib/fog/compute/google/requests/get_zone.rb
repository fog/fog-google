module Fog
  module Compute
    class Google
      class Mock
        def get_zone(_zone_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_zone(zone_name)
          @compute.get_zone(@project, zone_name)
        end
      end
    end
  end
end
