module Fog
  module Compute
    class Google
      class TargetInstance < Fog::Model
        identity :name

        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :description
        attribute :id
        attribute :instance
        attribute :kind
        attribute :nat_policy, :aliases => "natPolicy"
        attribute :self_link, :aliases => "selfLink"
        attribute :zone

        def save
          requires :identity, :zone

          options = {
            :description => description,
            :zone => zone,
            :nat_policy => nat_policy,
            :instance => instance
          }

          data = service.insert_target_instance(identity, zone, options)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name, data.zone)
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async = true)
          requires :name, :zone
          data = service.delete_target_instance(name, zone)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name, data.zone)
          operation.wait_for { ready? } unless async
          operation
        end

        def ready?
          service.get_target_instance(name, zone)
          true
        rescue Fog::Errors::NotFound
          false
        end

        def reload
          requires :name, :zone

          begin
            data = collection.get(name, zone)
            new_attributes = data.attributes
            merge_attributes(new_attributes)
            return self
          rescue Excon::Errors::SocketError
            return nil
          end
        end

        RUNNING_STATE = "READY".freeze
      end
    end
  end
end
