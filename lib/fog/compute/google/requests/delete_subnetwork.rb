module Fog
  module Compute
    class Google
      class Mock
        def delete_subnetwork(subnetwork_name, region_name)
          subnetwork_name = subnetwork_name.split("/")[-1] if subnetwork_name.start_with? "http"
          region_name = region_name.split("/")[-1] if region_name.start_with? "http"
          get_subnetwork(subnetwork_name, region_name)

          operation = random_operation
          data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/subnetworks/#{subnetwork_name}",
            "targetId" => data[:subnetworks][subnetwork_name]["id"],
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/operations/#{operation}",
            "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}",
          }
          data[:subnetworks].delete subnetwork_name

          build_excon_response(data[:operations][operation])
        end
      end

      class Real
        def delete_subnetwork(subnetwork_name, region_name)
          if region_name.start_with? "http"
            region_name = region_name.split("/")[-1]
          end

          api_method = @compute.subnetworks.delete
          parameters = {
            "project"    => @project,
            "region"     => region_name,
            "subnetwork" => subnetwork_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
