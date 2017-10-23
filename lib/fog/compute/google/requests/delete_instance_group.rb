module Fog
  module Compute
    class Google
      class Mock
        def delete_instance_group(_group_name, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_instance_group(group_name, zone)
          @compute.delete_instance_group(@project, zone, group_name)
        end
      end
    end
  end
end
