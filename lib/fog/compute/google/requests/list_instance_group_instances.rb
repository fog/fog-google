module Fog
  module Compute
    class Google
      class Mock
        def list_instance_group_instances(_group, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_instance_group_instances(group_name, zone)
          @compute.list_instance_group_instances(@project,
                                                 zone,
                                                 group_name)
        end
      end
    end
  end
end
