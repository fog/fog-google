module Fog
  module Compute
    class Google
      class Mock
        def insert_subnetwork(subnetwork_name, region_name, network, ip_range, _options = {})
          subnetwork_name = subnetwork_name.split("/")[-1] if subnetwork_name.start_with? "http"
          region_name = region_name.split("/")[-1] if region_name.start_with? "http"
          network_name = network.split("/")[-1]

          gateway = ip_range.split("/").first.split(".")
          gateway[-1] = "1"

          id = Fog::Mock.random_numbers(19).to_s
          object = {
            "kind" => "compute#subnetwork",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "gatewayAddress" => gateway.join("."),
            "name" => subnetwork_name,
            "network" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/networks/#{network_name}",
            "ipCidrRange" => ip_range,
            "region" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/subnetworks/#{subnetwork_name}"
          }

          data[:subnetworks][subnetwork_name] = object

          operation = random_operation
          data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "region" => object["region"],
            "operationType" => "insert",
            "targetLink" => object["selfLink"],
            "targetId" => id,
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "#{object['region']}/operations/#{operation}"
          }

          build_excon_response(data[:operations][operation])
        end
      end

      class Real
        def insert_subnetwork(subnetwork_name, region_name, network, ip_range, options = {})
          region_name = region_name.split("/")[-1] if region_name.start_with? "http"

          unless network.start_with? "http"
            network = "#{@api_url}#{@project}/global/networks/#{network}"
          end

          api_method = @compute.subnetworks.insert
          parameters = {
            "project" => @project,
            "region"  => region_name
          }
          body_object = {
            "ipCidrRange" => ip_range,
            "name"        => subnetwork_name,
            "network"     => network
          }

          body_object["description"] = options[:description] if options[:description]

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
