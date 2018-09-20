module Fog
  module Google
    class Compute
      class Routes < Fog::Collection
        model Fog::Google::Compute::Route

        def all
          data = service.list_routes.to_h
          load(data[:items] || [])
        end

        def get(identity)
          if route = service.get_route(identity).to_h
            new(route)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
