module Fog
  module Compute
    class Google
      class Networks < Fog::Collection
        model Fog::Compute::Google::Network

        def all
          data = service.list_networks.to_h[:items]
          load(data || [])
        end

        def get(identity)
          if identity
            network = service.get_network(identity).to_h
            return new(network)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
