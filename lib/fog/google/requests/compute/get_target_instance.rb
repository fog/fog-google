module Fog
  module Compute
    class Google
      class Mock
        def get_target_instance(name, _zone_name)
          target_instance = data[:target_instances][name]
          return nil if target_instance.nil?
          build_excon_response(target_instance)
        end
      end

      class Real
        def get_target_instance(target_instance_name, zone_name)
          zone_name = zone_name.split("/")[-1] if zone_name.start_with? "http"

          api_method = @compute.target_instances.get
          parameters = {
            "project" => @project,
            "targetInstance" => target_instance_name,
            "zone" => zone_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
