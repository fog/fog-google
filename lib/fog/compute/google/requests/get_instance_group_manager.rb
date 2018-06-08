module Fog
  module Compute
    class Google
      class Mock
        def get_instance_group_manager(_name, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_instance_group_manager(name, zone)
          @compute.get_instance_group_manager(@project, zone, name)
        end
      end
    end
  end
end
