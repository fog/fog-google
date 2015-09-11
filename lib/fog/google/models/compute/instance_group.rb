require 'fog/core/model'

module Fog
  module Compute
    class Google
      class InstanceGroup < Fog::Model
        identity :name

        attribute :id
        attribute :kind
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description
        attribute :fingerprint
        attribute :namedPorts
        attribute :network
        attribute :self_link, :aliases => 'selfLink'
        attribute :size
        attribute :zone, :aliases => :zone_name

        def save
          requires :name, :zone

          data = service.insert_instance_group(name, zone)
        end

        def destroy(async=true)
          requires :name, :zone

          data = service.delete_instance_group(name, zone)
        end

        def add_instance
          requires :name, :zone, :instance_name

          data = service.add_group_instance_instance(name, zone, instance_name)
        end

        def delete_instance
          requires :name, :zone,  :instance_name

          data = service.remove_group_instance_instance(name, zone, instance_name)
        end
      end
    end
  end
end
