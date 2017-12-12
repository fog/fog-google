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
          if target_https_proxy = service.get_target_https_proxy(identity).to_h
            new(target_https_proxy)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
