module Fog
  module Compute
    class Google
      class Subnetworks < Fog::Collection
        model Fog::Compute::Google::Subnetwork

        def all(region: nil, filter: nil, max_results: nil, order_by: nil, page_token: nil)
          filters = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }

          if region.nil?
            data = []
            service.list_aggregated_subnetworks(filters).to_h[:items].each_value do |region_obj|
              data.concat(region_obj[:subnetworks]) if region_obj[:subnetworks]
            end
          else
            data = service.list_subnetworks(region, filters).to_h[:items]
          end
          load(data || [])
        end

        def get(identity, region)
          if subnetwork = service.get_subnetwork(identity, region).to_h
            new(subnetwork)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
