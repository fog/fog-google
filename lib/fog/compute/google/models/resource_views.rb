module Fog
  module Compute
    class Google
      class ResourceViews < Fog::Collection
        model Fog::Compute::Google::ResourceView

        def all(filters = {})
          if filters["region"].nil? && filters["zone"].nil?
            data = []
            service.list_regions.body["items"].each do |region|
              data += service.list_region_views(region["name"]).body["items"] || []
            end
            service.list_zones.body["items"].each do |zone|
              data += service.list_zone_views(zone["name"]).body["items"] || []
            end
          elsif filters["zone"]
            data = service.list_zone_views(filters["zone"]).body["items"] || []
          else
            data = service.list_region_views(filters["region"]).body["items"] || []
          end
          load(data)
        end

        def get(identity, region = nil, zone = nil)
          response = nil

          if region.nil? & zone.nil?
            service.list_regions.body["items"].each do |region|
              begin
                response = service.get_region_view(identity, region["name"])
                break if response.status == 200
              rescue Fog::Errors::Error
              end
            end
            service.list_zones.body["items"].each do |zone|
              begin
                response = service.get_zone_view(identity, zone["name"])
                break if response.status == 200
              rescue Fog::Errors::Error
              end
            end
          elsif region
            response = service.get_region_view(identity, region)
          else
            response = service.get_zone_view(identity, zone)
          end

          return nil if response.nil?
          new(response.body)
        end
      end
    end
  end
end
