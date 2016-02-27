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
          api_method = @compute.instance_groups.get
          parameters = {
            "instanceGroup" => group_name,
            "project" => project,
            "zone" => zone
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
