module Fog
  module Compute
    class Google
      class Mock
        def remove_instance_group_instance(group_name, zone, instances)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def remove_instance_group_instance(group_name, zone, instance_name)
          api_method = @compute.instance_groups.remove_instances

          parameters = {
            'project' => @project,
            'instanceGroup' => group_name,
            'zone' => zone
          }

          body_object = {
            "instances" => [
              {
                "instance" => "https://www.googleapis.com/compute/v1/projects/chaostest-1/zones/us-central1-a/instances/inst-1\n"
              }
            ]
          }

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
