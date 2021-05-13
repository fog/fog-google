module Fog
  module Compute
    class Google
      class Operations < Fog::Collection
        model Fog::Compute::Google::Operation

        def all(zone: nil, region: nil, filter: nil, max_results: nil,
                order_by: nil, page_token: nil)
          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }

          if zone
            data = service.list_zone_operations(zone, **opts).to_h[:items]
          elsif region
            data = service.list_region_operations(region, **opts).to_h[:items]
          else
            data = service.list_global_operations(**opts).to_h[:items]
          end

          load(data || [])
        end

        def get(identity, zone = nil, region = nil)
          if !zone.nil?
            operation = service.get_zone_operation(zone, identity).to_h
            return new(operation)
          elsif !region.nil?
            operation = service.get_region_operation(region, identity).to_h
            return new(operation)
          elsif identity
            operation = service.get_global_operation(identity).to_h
            return new(operation)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
