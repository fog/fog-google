require 'fog/core/collection'
require 'fog/google/models/compute/instance_group'

module Fog
  module Compute
    class Google
      class InstanceGroups < Fog::Collection
        model Fog::Compute::Google::InstanceGroup

        def all(params={})
          data = service.list_instance_groups(params[:zone]).body
          load(data['items'] || [])
        end

        def get(identity, zone_name=nil)
          if zone_name.nil?
            zones = service.list_aggregated_instance_groups(:filter => "name eq .*#{identity}").body['items']
            target_zone = zones.each_value.select { |zone| zone.key?('instanceGroups') }
            response = target_zone.first['instanceGroups'].first unless target_zone.empty?
            zone_name = response['zone'].split('/')[-1]
          end

          if instance_group = service.get_instance_group(identity,zone_name).body
            new(instance_group)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
