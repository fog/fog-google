module Fog
  module Compute
    class Google
      class Mock
        def add_instance_group_instances(_group, _zone, _instances)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def remove_instance_group_instances(group_name, zone, instances)
          api_method = @compute.instance_groups.remove_instances

          parameters = {
            "project" => @project,
            "instanceGroup" => group_name,
            "zone" => zone
          }

          instances.map! do |instance|
            if instance.start_with?("https:")
              { "instance" => instance }
            else
              { "instance" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone}/instances/#{instance}\n" }
            end
          end

          body_object = {
            "instances" => instances
          }

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
