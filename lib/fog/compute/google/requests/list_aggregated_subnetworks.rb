module Fog
  module Compute
    class Google
      class Mock
        def list_aggregated_subnetworks(_options = {})
          subnetworks_by_region = data[:subnetworks].each_with_object({}) do |(_, subnetwork), memo|
            region = subnetwork["region"].split("/")[-2..-1].join("/")
            memo[region] ||= { "subnetworks" => [] }
            memo[region]["subnetworks"].push subnetwork
          end

          build_excon_response("kind" => "compute#subnetworkAggregatedList",
                               "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/aggregated/subnetworks",
                               "items" => subnetworks_by_region)
        end
      end

      class Real
        def list_aggregated_subnetworks(options = {})
          api_method = @compute.subnetworks.aggregated_list
          parameters = {
            "project" => @project
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
