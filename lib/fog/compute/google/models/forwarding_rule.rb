module Fog
  module Compute
    class Google
      class ForwardingRule < Fog::Model
        identity :name

        attribute :ip_address, :aliases => "IPAddress"
        attribute :ip_protocol, :aliases => "IPProtocol"
        attribute :backend_service, :aliases => "backendService"
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :description
        attribute :id
        attribute :ip_version, :aliases => "ipVersion"
        attribute :kind
        attribute :load_balancing_scheme, :aliases => "loadBalancingScheme"
        attribute :network
        attribute :port_range, :aliases => "portRange"
        attribute :ports
        attribute :region
        attribute :self_link, :aliases => "selfLink"
        attribute :subnetwork
        attribute :target

        def save
          requires :identity, :region

          data = service.insert_forwarding_rule(identity, region, attributes)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name, nil, data.region)
          operation.wait_for { !pending? }
          reload
        end

        def set_target(new_target)
          requires :identity, :region

          new_target = new_target.self_link unless new_target.class == String
          self.target = new_target
          service.set_forwarding_rule_target(
            identity, region, :target => new_target
          )
          reload
        end

        def destroy(async = true)
          requires :identity, :region
          data = service.delete_forwarding_rule(identity, region)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name, nil, data.region)
          operation.wait_for { ready? } unless async
          operation
        end

        def ready?
          requires :identity
          service.get_forwarding_rule(identity, region)
          true
        rescue Fog::Errors::NotFound
          false
        end

        def reload
          requires :name, :region

          return unless data = begin
            collection.get(name, region)
          rescue Excon::Errors::SocketError
            nil
          end

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end
      end
    end
  end
end
