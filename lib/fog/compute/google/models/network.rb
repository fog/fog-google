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
          # Since network has no "state" we can query, we have to wait for the operation to finish
          # TODO: change back to async when there's a proper state API
          operation.wait_for { ready? }
          reload
        end

        def destroy(async = true)
          requires :identity

          data = service.delete_network(identity)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body["name"])
          operation.wait_for { ready? } unless async
          operation
        end

        def get_self_link_attr
          return [self_link]
        end

      end
    end
  end
end
