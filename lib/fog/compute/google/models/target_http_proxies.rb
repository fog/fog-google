module Fog
  module Compute
    class Google
      class TargetHttpProxies < Fog::Collection
        model Fog::Compute::Google::TargetHttpProxy

        def all(_filters = {})
          data = service.list_target_http_proxies.to_h[:items] || []
          load(data)
        end

        def get(identity)
          if identity
            target_http_proxy = service.get_target_http_proxy(identity).to_h
            return new(target_http_proxy)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
