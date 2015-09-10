module Fog
  module Compute
    class Google
      class Mock
        def delete_instance_group(group_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_instance_group(group_name, zone_name)
          api_method = @compute.instanceGroups.delete
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
