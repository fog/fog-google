module Fog
  module Compute
    class Google
      class Mock
        def delete_instance_group(group_name, zone_name)
          build_excon_response({
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/#{project}/zones/#{zone_name}/instanceGroups/#{group_name}",
          })
          #Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_instance_group(group_name, zone_name)
          api_method = @compute.instance_groups.delete
          parameters = {
            'instanceGroup' => group_name,
            'project' => @project,
            'zone' => zone_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
