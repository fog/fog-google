module Fog
  module Compute
    class Google
      class Subnetworks < Fog::Collection
        model Fog::Compute::Google::Subnetwork

        def all(filters = {})
          if filters[:region]
            data = service.list_subnetworks(filters[:region]).body["items"] || []
          else
            data = []
            service.list_aggregated_subnetworks(filters).body["items"].each_value do |region|
              data.concat(region["subnetworks"]) if region["subnetworks"]
            end
          end
          load(data || [])
        end

        def get(identity, region)
          if subnetwork = service.get_subnetwork(identity, region).body
            new(subnetwork)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
