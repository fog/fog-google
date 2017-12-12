module Fog
  module Compute
    class Google
      ##
      # Represents a Firewall resource
      #
      # @see https://developers.google.com/compute/docs/reference/latest/firewalls
      class Firewall < Fog::Model
        identity :name

        attribute :allowed
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :denied
        attribute :description
        attribute :destination_ranges, :aliases => "destinationRanges"
        attribute :direction
        attribute :id
        attribute :kind
        attribute :network
        attribute :priority
        attribute :self_link, :aliases => "selfLink"
        attribute :source_ranges, :aliases => "sourceRanges"
        attribute :source_service_accounts, :aliases => "sourceServiceAccounts"
        attribute :source_tags, :aliases => "sourceTags"
        attribute :target_service_accounts, :aliases => "targetServiceAccounts"
        attribute :target_tags, :aliases => "targetTags"

        def save
          requires :identity

          id.nil? ? create : update
        end

        def create
          data = service.insert_firewall(identity, attributes)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { !pending? }
          reload
        end

        def update
          requires :identity, :allowed, :network

          data = service.update_firewall(identity, attributes)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { !pending? }
          reload
        end

        def patch(diff = {})
          requires :identity

          data = service.patch_firewall(identity, diff)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async = true)
          requires :identity

          data = service.delete_firewall(identity)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { ready? } unless async
          operation
        end
      end
    end
  end
end
