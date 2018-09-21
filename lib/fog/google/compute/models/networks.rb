module Fog
  module Google
    class Compute
      class Networks < Fog::Collection
        model Fog::Google::Compute::Network

        def all
          data = service.list_networks.to_h[:items]
          load(data || [])
        end

        def get(identity)
          if network = service.get_network(identity).to_h
            new(network)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
