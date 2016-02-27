module Fog
  module Compute
    class Google
      class Mock
        def delete_zone_operation(_zone, _operation)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # https://developers.google.com/compute/docs/reference/latest/zoneOperations

        def delete_zone_operation(zone_name, operation)
          zone_name = zone_name.split("/")[-1] if zone_name.start_with? "http"
          api_method = @compute.zone_operations.delete
          parameters = {
            "project" => @project,
            "zone" => zone_name,
            "operation" => operation
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
