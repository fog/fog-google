module Fog
  module Compute
    class Google
      class DiskTypes < Fog::Collection
        model Fog::Compute::Google::DiskType

        def all(zone: nil, filter: nil, max_results: nil,
                order_by: nil, page_token: nil)
          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }
          if zone
            data = service.list_disk_types(zone, opts).items
          else
            data = []
            service.list_aggregated_disk_types(opts).items.each_value do |scoped_lst|
              data.concat(scoped_lst.disk_types) if scoped_lst && scoped_lst.disk_types
            end
          end
          load(data.map(&:to_h))
        end

        def get(identity, zone = nil)
          if zone
            disk_type = service.get_disk_type(identity, zone).to_h
            return new(disk_type)
          else
            response = all(:filter => "name eq .*#{identity}")
            disk_type = response.first unless response.empty?
            return disk_type
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
