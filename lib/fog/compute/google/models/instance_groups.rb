module Fog
  module Compute
    class Google
      class InstanceGroups < Fog::Collection
        model Fog::Compute::Google::InstanceGroup

        def all(filters = {})
          if filters[:zone]
            data = Array(service.list_instance_groups(filters[:zone]))
          else
            data = []
            service.list_aggregated_instance_groups.items.each_value do |group|
              data.concat(group.instance_groups) if group.instance_groups
            end
          end

          load(data.map(&:to_h))
        end

        def get(identity, zone = nil)
          if zone.nil?
            zones = service.list_aggregated_instance_groups(:filter => "name eq .*#{identity}").items
            instance_groups = zones.each_value.map(&:instance_groups).compact.first
            if instance_groups
              zone = instance_groups.first.zone.split("/")[-1]
            end
          end

          if instance_group = service.get_instance_group(identity, zone)
            new(instance_group.to_h)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end

        # TODO: To be deprecated
        def add_instance(params)
          Fog::Logger.deprecation(
            "#{self.class}.#{__method__} is deprecated, use Fog::Compute::Google::InstanceGroup.#{__method__} instead [light_black](#{caller(0..0)})[/]"
          )
          params[:instance] = [params[:instance]] unless params[:instance] == Array
          service.add_instance_group_instances(params[:group], params[:zone], params[:instance])
        end

        # TODO: To be deprecated
        def remove_instance(params)
          Fog::Logger.deprecation(
            "#{self.class}.#{__method__} is deprecated, use Fog::Compute::Google::InstanceGroup.#{__method__} instead [light_black](#{caller(0..0)})[/]"
          )
          params[:instance] = [params[:instance]] unless params[:instance] == Array
          service.remove_instance_group_instances(params[:group], params[:zone], params[:instance])
        end
      end
    end
  end
end
