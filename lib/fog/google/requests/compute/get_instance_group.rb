module Fog
  module Compute
    class Google
      class Mock
        def get_instance_group(group_name, zone_name, project=@project)
          build_excon_response({
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/#{project}/zones/#{zone_name}/instanceGroups",
          })
        end
      end

      class Real
        def get_instance_group(group_name, zone_name, project=@project)
          api_method = @compute.instance_groups.get
          parameters = {
            'instanceGroup' => group_name,
            'project' => project,
            'zone' => zone_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
