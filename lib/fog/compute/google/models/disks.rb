module Fog
  module Compute
    class Google
      class Disks < Fog::Collection
        model Fog::Compute::Google::Disk

        def all(zone: nil, filter: nil, max_results: nil, order_by: nil,
                page_token: nil)
          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }
          if zone
            data = service.list_disks(zone, opts).items || []
          else
            data = []
            service.list_aggregated_disks(opts).items.each_value do |scoped_list|
              data.concat(scoped_list.disks) if scoped_list.disks
            end
          end
          load(data.map(&:to_h))
        end

        def get(identity, zone)
          response = service.get_disk(identity, zone)
          return nil if response.nil?
          new(response.to_h)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
