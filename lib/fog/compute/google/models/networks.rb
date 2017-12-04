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
          if network = service.get_network(identity).to_h
            new(network)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
