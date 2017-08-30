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
          if backend_service = service.get_backend_service(identity).body
            new(backend_service)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
