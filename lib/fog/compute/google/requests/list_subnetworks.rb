module Fog
  module Compute
    class Google
      class Mock
        def list_subnetworks(region_name)
          region_name = region_name.split("/")[-1] if region_name.start_with? "http"
          subnetworks = data[:subnetworks].values.select { |d| d["region"].split("/")[-1] == region_name }

          build_excon_response("kind" => "compute#subnetworkList",
                               "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/regions/#{region_name}/subnetworks",
                               "id" => "projects/#{@project}/regions/#{region_name}/subnetworks",
                               "items" => subnetworks)
        end
      end

      class Real
        def list_subnetworks(region_name, options = {})
          region_name = region_name.split("/")[-1] if region_name.start_with? "http"

          api_method = @compute.subnetworks.list
          parameters = {
            "project" => @project,
            "region"  => region_name
          }

          parameters["filter"] = options[:filter] if options[:filter]
          parameters["maxResults"] = options[:max_results] if options[:max_results]
          parameters["pageToken"] = options[:page_token] if options[:page_token]

          request(api_method, parameters)
        end
      end
    end
  end
end
