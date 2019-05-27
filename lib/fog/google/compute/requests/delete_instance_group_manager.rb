module Fog
  module Google
    class Compute
      class Mock
        def delete_instance_group_manager(_name, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_instance_group_manager(name, zone)
          @compute.delete_instance_group_manager(@project, zone, name)
        end
      end
    end
  end
end
