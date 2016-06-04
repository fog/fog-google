module Fog
  module Compute
    class Google
      class InstanceGroup < Fog::Model
        identity :name

        attribute :id
        attribute :kind
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :description
        attribute :fingerprint
        attribute :namedPorts
        attribute :network
        attribute :self_link, :aliases => "selfLink"
        attribute :size
        attribute :zone, :aliases => :zone_name

        def save
          requires :name, :zone

          data = service.insert_instance_group(name, zone)
        end

        def destroy(_async = true)
          requires :name, :zone

          data = service.delete_instance_group(name, zone_name)
        end

        def add_instances(instances)
          requires :identity, :zone

          service.add_instance_group_instances(
            identity, zone_name, format_instance_list(instances)
          )
        end

        def remove_instances(instances)
          requires :identity, :zone

          service.remove_instance_group_instances(
            identity, zone_name, format_instance_list(instances)
          )
        end

        def list_instances
          requires :identity, :zone

          data = service.list_instance_group_instances(identity, zone_name).body
          data["items"]
        end

        def zone_name
          zone.nil? ? nil : zone.split("/")[-1]
        end

        private

        def format_instance_list(instance_list)
          instance_list = [instance_list] unless instance_list.class == Array
          instance_list.map { |i| i.class == String ? i : i.self_link }
        end
      end
    end
  end
end
