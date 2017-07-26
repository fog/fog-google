module Fog
  module Compute
    class Google
      class Operations < Fog::Collection
        model Fog::Compute::Google::Operation

        def all(filters = {})
          data = service.list_global_operations.body
          if filters.zone
            data = service.list_zone_operations(filters.zone).body
          elsif filters.region
            data = service.list_region_operations(filters.region).body
          end

          load(data.items || [])
        end

        def get(identity, zone = nil, region = nil)
          response = service.get_global_operation(identity)
          if !zone.nil?
            response = service.get_zone_operation(zone, identity)
          elsif !region.nil?
            response = service.get_region_operation(region, identity)
          end

          return nil if response.nil?
          new(response.to_h)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
