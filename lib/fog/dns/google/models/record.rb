module Fog
  module DNS
    class Google
      ##
      # Resource Record Sets resource
      #
      # @see https://cloud.google.com/dns/api/v1/resourceRecordSets
      class Record < Fog::Model
        identity :name

        attribute :kind
        attribute :type
        attribute :ttl
        attribute :rrdatas

        ##
        # Deletes a previously created Resource Record Sets resource
        #
        # @param [Boolean] async If the operation must be asyncronous (true by default)
        # @return [Boolean] If the Resource Record Set has been deleted
        def destroy(async = true)
          requires :name, :type, :ttl, :rrdatas

          data = service.create_change(zone.id, [], [resource_record_set_format])
          change = Fog::DNS::Google::Changes.new(:service => service, :zone => zone).get(data.body["id"])
          change.wait_for { ready? } unless async
          true
        end

        ##
        # Modifies a previously created Resource Record Sets resource
        #
        # @param [Hash] new_attributes Resource Record Set new attributes
        # @return [Fog::DNS::Google::Record] Resource Record Sets resource
        def modify(new_attributes)
          requires :name, :type, :ttl, :rrdatas

          deletions = resource_record_set_format
          merge_attributes(new_attributes)

          data = service.create_change(zone.id, [resource_record_set_format], [deletions])
          change = Fog::DNS::Google::Changes.new(:service => service, :zone => zone).get(data.body["id"])
          async = new_attributes.key?(:async) ? new_attributes[:async] : true
          change.wait_for { ready? } unless async
          self
        end

        ##
        # Reloads a Resource Record Sets resource
        #
        # @return [Fog::DNS::Google::Record] Resource Record Sets resource
        def reload
          requires :name, :type

          data = collection.get(name, type)
          merge_attributes(data.attributes)
          self
        end

        ##
        # Creates a new Resource Record Sets resource
        #
        # @return [Fog::DNS::Google::Record] Resource Record Sets resource
        def save
          requires :name, :type, :ttl, :rrdatas

          data = service.create_change(zone.id, [resource_record_set_format], [])
          change = Fog::DNS::Google::Changes.new(:service => service, :zone => zone).get(data.body["id"])
          change.wait_for { !pending? }
          self
        end

        ##
        # Returns the Managed Zone of the Resource Record Sets resource
        #
        # @return [Fog::DNS::Google::Zone] Managed Zone of the Resource Record Sets resource
        attr_reader :zone

        private

        ##
        # Assigns the Managed Zone of the Resource Record Sets resource
        #
        # @param [Fog::DNS::Google::Zone] new_zone Managed Zone of the Resource Record Sets resource
        attr_writer :zone

        ##
        # Resource Record Sets resource representation
        #
        def resource_record_set_format
          {
            "kind" => 'dns#resourceRecordSet',
            "name" => name,
            "type" => type,
            "ttl"  => ttl,
            "rrdatas" => rrdatas
          }
        end
      end
    end
  end
end
