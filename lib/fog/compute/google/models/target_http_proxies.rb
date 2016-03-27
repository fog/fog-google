module Fog
  module Compute
    class Google
      class TargetHttpProxies < Fog::Collection
        model Fog::Compute::Google::TargetHttpProxy

        def all(_filters = {})
          data = service.list_target_http_proxies.body["items"] || []
          load(data)
        end

        def get(identity)
          if target_http_proxy = service.get_target_http_proxy(identity).body
            new(target_http_proxy)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
