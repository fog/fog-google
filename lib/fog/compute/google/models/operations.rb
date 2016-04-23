module Fog
  module Compute
    class Google
      class Operations < Fog::Collection
        model Fog::Compute::Google::Operation

        def all(filters = {})
          data = if filters["zone"]
                   service.list_zone_operations(filters["zone"]).body
                 elsif filters["region"]
                   service.list_region_operations(filters["region"]).body
                 else
                   service.list_global_operations.body
                 end
          load(data["items"] || [])
        end

        def get(identity, zone = nil, region = nil)
          response = if !zone.nil?
                       service.get_zone_operation(zone, identity)
                     elsif !region.nil?
                       service.get_region_operation(region, identity)
                     else
                       service.get_global_operation(identity)
                     end
          return nil if response.nil?
          new(response.body)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
