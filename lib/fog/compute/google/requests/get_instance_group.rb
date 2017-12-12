module Fog
  module Compute
    class Google
      class Mock
        def get_instance_group(_group_name, _zone, _project = @project)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_instance_group(group_name, zone, project = @project)
          @compute.get_instance_group(project, zone, group_name)
        end
      end
    end
  end
end
