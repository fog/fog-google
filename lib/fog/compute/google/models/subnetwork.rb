module Fog
  module Compute
    class Google
      ##
      # Represents a Subnetwork resource
      #
      # @see https://developers.google.com/compute/docs/reference/latest/subnetworks
      class Subnetwork < Fog::Model
        identity :name

        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :description
        attribute :gateway_address, :aliases => "gatewayAddress"
        attribute :id
        attribute :ip_cidr_range, :aliases => "ipCidrRange"
        attribute :kind
        attribute :network
        attribute :region
        attribute :self_link, :aliases => "selfLink"

        def save
          requires :identity, :network, :region, :ip_cidr_range

          data = service.insert_subnetwork(identity, region, network, ip_cidr_range, attributes)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body["name"], nil, data.body["region"])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async = true)
          requires :identity, :region

          data = service.delete_subnetwork(identity, region)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body["name"], nil, data.body["region"])
          operation.wait_for { ready? } unless async
          operation
        end

        def reload
          requires :identity, :region

          data = collection.get(identity, region.split("/")[-1])
          merge_attributes(data.attributes)
          self
        end
      end
    end
  end
end
