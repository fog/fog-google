module Fog
  module Compute
    class Google
      class InstanceGroupManagers < Fog::Collection
        model Fog::Compute::Google::InstanceGroupManager

        def all(zone: nil, filter: nil, max_results: nil,
                order_by: nil, page_token: nil)
          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }
          data = []
          if zone
            data += service.list_instance_group_managers(zone, opts).items || []
          else
            service.list_aggregated_instance_group_managers(opts).items.each_value do |group|
              data.concat(group.instance_group_managers) if group.instance_group_managers
            end
          end

          load(data.map(&:to_h))
        end

        def get(identity, zone = nil)
          if zone
            if instance_group_manager = service.get_instance_group_manager(identity, zone)
              new(instance_group_manager.to_h)
            end
          else
            all(:filter => "name eq .*#{identity}").first
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
