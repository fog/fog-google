module Fog
  module Compute
    class Google
      ##
      # Represents a Network resource
      #
      # @see https://developers.google.com/compute/docs/reference/latest/networks
      class Network < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :ipv4_range, :aliases => "IPv4Range"
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :description
        attribute :gateway_ipv4, :aliases => "gatewayIPv4"
        attribute :self_link, :aliases => "selfLink"

        def save
          requires :identity, :ipv4_range

          data = service.insert_network(identity, ipv4_range, attributes)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body["name"])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async = true)
          requires :identity

          data = service.delete_network(identity)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body["name"])
          operation.wait_for { ready? } unless async
          operation
        end

        # Returns a ready API structure for insert_instance, used in insert_server request.
        def get_as_interface_config(access_config=nil)
          network_interface = { "network" => self_link }
          network_interface["accessConfigs"] = [access_config] if access_config
          network_interface
        end
      end
    end
  end
end
