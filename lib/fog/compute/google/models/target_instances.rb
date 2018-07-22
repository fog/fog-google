module Fog
  module Compute
    class Google
      class TargetInstances < Fog::Collection
        model Fog::Compute::Google::TargetInstance

        def all(zone: nil, filter: nil, max_results: nil, order_by: nil,
                page_token: nil)
          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }

          if zone
            data = service.list_target_instances(zone, opts).to_h[:items] || []
          else
            data = []
            service.list_aggregated_target_instances(opts).items.each_value do |scoped_list|
              unless scoped_list.nil? || scoped_list.target_instances.nil?
                data += scoped_list.target_instances.map(&:to_h)
              end
            end
          end
          load(data)
        end

        def get(identity, zone = nil)
          if zone
            target_instance = service.get_target_instance(target_instance, zone).to_h
            return new(target_instance)
          elsif identity
            response = all(:filter => "name eq #{identity}",
                           :max_results => 1)
            target_instance = response.first unless response.empty?
            return target_instance
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
