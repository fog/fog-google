module Fog
  module Compute
    class Google
      class Mock
        def list_instance_groups(zone_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_instance_groups(zone_name)
          api_method = @compute.instanceGroups.list
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
