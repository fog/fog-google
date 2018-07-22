module Fog
  module Compute
    class Google
      class MachineTypes < Fog::Collection
        model Fog::Compute::Google::MachineType

        def all(zone: nil, filter: nil, max_results: nil, order_by: nil, page_token: nil)
          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }

          if zone
            data = service.list_machine_types(zone, opts).items
          else
            data = []
            service.list_aggregated_machine_types(opts).items.each_value do |scoped_list|
              data.concat(scoped_list.machine_types) if scoped_list && scoped_list.machine_types
            end
          end
          load(data.map(&:to_h) || [])
        end

        def get(identity, zone = nil)
          if zone
            machine_type = service.get_machine_type(identity, zone).to_h
            return new(machine_type)
          elsif identity
            # This isn't very functional since it just shows the first available
            # machine type globally, but needed due to overall compatibility
            # See: https://github.com/fog/fog-google/issues/352
            response = all(:filter => "name eq #{identity}",
                           :max_results => 1)
            machine_type = response.first unless response.empty?
            return machine_type
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
