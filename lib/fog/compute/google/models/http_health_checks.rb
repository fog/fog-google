module Fog
  module Compute
    class Google
      class HttpHealthChecks < Fog::Collection
        model Fog::Compute::Google::HttpHealthCheck

        def all(_filters = {})
          data = service.list_http_health_checks.to_h[:items] || []
          load(data)
        end

        def get(identity)
          if identity
            http_health_check = service.get_http_health_check(identity).to_h
            return new(http_health_check)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
