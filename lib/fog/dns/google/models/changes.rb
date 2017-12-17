module Fog
  module DNS
    class Google
      class Changes < Fog::Collection
        model Fog::DNS::Google::Change

        attribute :zone

        ##
        # Enumerates the list of Changes
        #
        # @return [Array<Fog::DNS::Google::Change>] List of Changes resources
        def all
          requires :zone

          data = service.list_changes(zone.identity).to_h[:changes] || []
          load(data)
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          []
        end

        ##
        # Fetches the representation of an existing Change
        #
        # @param [String] identity Change identity
        # @return [Fog::DNS::Google::Change] Change resource
        def get(identity)
          requires :zone
          if change = service.get_change(zone.identity, identity).to_h
            new(change)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end

        ##
        # Creates a new instance of a Change
        #
        # @return [Fog::DNS::Google::Change] Change resource
        def new(attributes = {})
          requires :zone

          super({ :zone => zone }.merge!(attributes))
        end
      end
    end
  end
end
