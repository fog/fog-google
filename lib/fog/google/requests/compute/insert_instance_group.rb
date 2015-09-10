module Fog
  module Compute
    class Google
      class Mock
        def insert_instance_group(group_name, zone_name, options = {})
          build_excon_response({
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/#{project}/zones/#{zone_name}/instanceGroupszzz",
            "name" => group_name
          })
        end
      end

      class Real
        def insert_instance_group(group_name, zone_name, options = {})
          api_method = @compute.instanceGroups.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }

          body = {
            'name' => group_name
          }

          request(api_method, parameters, body)
        end
      end
    end
  end
end
