module Fog
  module Compute
    class Google
      ##
      # Represents a Network resource
      #
      # @see https://developers.google.com/compute/docs/reference/latest/networks
      class Network < Fog::Model
        identity :name

        attribute :auto_create_subnetworks, aliases => "autoCreateSubnetworks"
        attribute :creation_timestamp, aliases => "creationTimestamp"
        attribute :description
        attribute :gateway_ipv4, aliases => %w(gateway_i_pv4 gatewayIPv4)
        attribute :ipv4_range, aliases => %w(i_pv4_range IPv4Range)
        attribute :id
        attribute :kind
        attribute :peerings
        attribute :routing_config, aliases => "routingConfig"
        attribute :self_link, aliases => "selfLink"
        attribute :subnetworks

        def save
          requires :identity, :ipv4_range

          data = service.insert_network(identity, attributes)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          # Since network has no "state" we can query, we have to wait for the operation to finish
          # TODO: change back to async when there's a proper state API
          operation.wait_for { ready? }
          reload
        end

        def destroy(async = true)
          requires :identity

          data = service.delete_network(identity)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { ready? } unless async
          operation
        end

        # Returns a ready API structure for insert_instance, used in insert_server request.
        def get_as_interface_config(access_config = nil)
          network_interface = { :network => self_link }
          network_interface[:access_configs] = [access_config] if access_config
          network_interface
        end
      end
    end
  end
end
