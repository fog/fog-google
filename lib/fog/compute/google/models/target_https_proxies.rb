module Fog
  module Compute
    class Google
      class TargetHttpsProxies < Fog::Collection
        model Fog::Compute::Google::TargetHttpsProxy

        def all(_filters = {})
          data = service.list_target_https_proxies.to_h[:items] || []
          load(data)
        end

        def get(identity)
          if identity
            target_https_proxy = service.get_target_https_proxy(identity).to_h
            return new(target_https_proxy)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
