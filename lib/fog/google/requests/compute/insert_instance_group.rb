module Fog
  module Compute
    class Google
      class Mock
        def insert_instance_group(group_name, zone_name, options = {})
          object = {
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/#{project}/zones/#{zone_name}/instanceGroups",
            "name" => group_name
          }
          self.data[:instance_groups][group_name] = object

          build_excon_response(object)
        end
      end

      class Real
        def insert_instance_group(group_name, zone_name, options = {})
          api_method = @compute.instance_groups.insert
          parameters = {
            'project' => @project,
            'zone' => zone_name
          }

          id = Fog::Mock.random_numbers(19).to_s

          body = {
            'name' => group_name,
            'network' => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/networks/default",
          }
          body['description'] = options['description'] if options['description']

          request(api_method, parameters, body)
        end
      end
    end
  end
end
