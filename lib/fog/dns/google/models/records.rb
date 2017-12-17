module Fog
  module DNS
    class Google
      class Records < Fog::Collection
        model Fog::DNS::Google::Record

        attribute :zone

        ##
        # Enumerates Resource Record Sets that have been created but not yet deleted
        #
        # @return [Array<Fog::DNS::Google::Record>] List of Resource Record Sets resources
        def all
          requires :zone

          data = service.list_resource_record_sets(zone.identity)
                        .to_h[:rrsets] || []
          load(data)
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          []
        end

        ##
        # Fetches the representation of an existing Resource Record Set
        #
        # @param [String] name Resource Record Set name
        # @param [String] type Resource Record Set type
        # @return [Fog::DNS::Google::Record] Resource Record Set resource
        def get(name, type)
          requires :zone

          records = service.list_resource_record_sets(zone.identity, :name => name, :type => type)
                           .to_h[:rrsets] || []
          records.any? ? new(records.first) : nil
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end

        ##
        # Creates a new instance of a Resource Record Set
        #
        # @return [Fog::DNS::Google::Record] Resource Record Set resource
        def new(attributes = {})
          requires :zone

          super({ :zone => zone }.merge!(attributes))
        end
      end
    end
  end
end
