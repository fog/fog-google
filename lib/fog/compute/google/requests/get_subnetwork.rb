module Fog
  module Compute
    class Google
      class Mock
        def get_subnetwork(subnetwork_name, region_name)
          subnetwork_name = subnetwork_name.split("/")[-1] if subnetwork_name.start_with? "http"
          region_name = region_name.split("/")[-1] if region_name.start_with? "http"
          subnetwork = data[:subnetworks][subnetwork_name]

          unless subnetwork && subnetwork["region"].split("/")[-1] == region_name
            return build_excon_response("error" => {
                                          "errors" => [
                                            {
                                              "domain" => "global",
                                              "reason" => "notFound",
                                              "message" => "The resource 'projects/#{@project}/regions/#{region_name}/subnetworks/#{subnetwork_name}' was not found"
                                            }
                                          ],
                                          "code" => 404,
                                          "message" => "The resource 'projects/#{@project}/regions/#{region_name}/subnetworks/#{subnetwork_name}' was not found"
                                        })
          end

          build_excon_response(subnetwork)
        end
      end

      class Real
        def get_subnetwork(subnetwork_name, region_name)
          subnetwork_name = subnetwork_name.split("/")[-1] if subnetwork_name.start_with? "http"
          region_name = region_name.split("/")[-1] if region_name.start_with? "http"

          api_method = @compute.subnetworks.get
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
