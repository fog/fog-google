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
          response = service.get_http_health_check(identity)
          return nil if response.nil?
          new(response.to_h)
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
