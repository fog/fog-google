module Fog
  module Compute
    class Google
      class Disks < Fog::Collection
        model Fog::Compute::Google::Disk

        def all(filters = {})
          if filters["zone"]
            data = service.list_disks(filters["zone"]).items || []
          else
            data = []
            service.list_aggregated_disks.items.each_value do |zone|
              data.concat(zone.disks) if zone.disks
            end
          end
          load(data.map(&:to_h))
        end

        def get(identity, zone = nil)
          response = nil
          if zone
            response = service.get_disk(identity, zone)
          else
            disks = service.list_aggregated_disks(:filter => "name eq .*#{identity}").items
            disk = disks.each_value.select(&:disks)

            # It can only be 1 disk with the same name across all regions
            response = disk.first.disks.first unless disk.empty?
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
