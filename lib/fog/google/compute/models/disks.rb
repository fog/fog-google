module Fog
  module Google
    class Compute
      class Disks < Fog::Collection
        model Fog::Google::Compute::Disk

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

        def get(identity, zone = nil)
          if zone
            disk = service.get_disk(identity, zone).to_h
            return new(disk)
          elsif identity
            response = all(:filter => "name eq #{identity}",
                           :max_results => 1)
            disk = response.first unless response.empty?
            return disk
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end

        def attached_disk_obj(source,
                              writable: true,
                              boot: false,
                              device_name: nil,
                              encryption_key: nil,
                              auto_delete: false)
          {
            :auto_delete => auto_delete,
            :boot => boot,
            :device_name => device_name,
            :disk_encryption_key => encryption_key,
            :mode => writable ? "READ_WRITE" : "READ_ONLY",
            :source => source,
            :type => "PERSISTENT"
          }.reject { |_k, v| v.nil? }
        end
      end
    end
  end
end
