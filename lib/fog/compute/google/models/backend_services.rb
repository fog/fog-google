module Fog
  module Compute
    class Google
      class BackendServices < Fog::Collection
        model Fog::Compute::Google::BackendService

        def all(_filters = {})
          data = service.list_backend_services.items || []
          load(data.map(&:to_h))
        end

        def get(identity)
          if backend_service = service.get_backend_service(identity)
            new(backend_service.to_h)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
