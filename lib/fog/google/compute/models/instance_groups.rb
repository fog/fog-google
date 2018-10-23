module Fog
  module Google
    class Compute
      class InstanceGroups < Fog::Collection
        model Fog::Google::Compute::InstanceGroup

        def all(zone: nil, filter: nil, max_results: nil, order_by: nil, page_token: nil)
          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }

          if zone
            data = service.list_instance_groups(zone).items || []
          else
            data = []
            service.list_aggregated_instance_groups(opts).items.each_value do |group|
              data.concat(group.instance_groups) if group && group.instance_groups
            end
          end

          load(data.map(&:to_h))
        end

        def get(identity, zone = nil)
          if zone
            instance_group = service.get_instance_group(identity, zone).to_h
            new(instance_group)
          elsif identity
            response = all(:filter => "name eq #{identity}",
                           :max_results => 1)
            instance_group = response.first unless response.empty?
            return instance_group
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404

          nil
        end

        # TODO: To be deprecated
        def add_instance(params)
          Fog::Logger.deprecation(
            "#{self.class}.#{__method__} is deprecated, use Fog::Google::Compute::InstanceGroup.#{__method__} instead [light_black](#{caller(0..0)})[/]"
          )
          params[:instance] = [params[:instance]] unless params[:instance] == Array
          service.add_instance_group_instances(params[:group], params[:zone], params[:instance])
        end

        # TODO: To be deprecated
        def remove_instance(params)
          Fog::Logger.deprecation(
            "#{self.class}.#{__method__} is deprecated, use Fog::Google::Compute::InstanceGroup.#{__method__} instead [light_black](#{caller(0..0)})[/]"
          )
          params[:instance] = [params[:instance]] unless params[:instance] == Array
          service.remove_instance_group_instances(params[:group], params[:zone], params[:instance])
        end
      end
    end
  end
end
