module Fog
  module Compute
    class Google
      class Mock
        def invalidate_url_map_cache(_url_map_name, _path, _host = nil)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def invalidate_url_map_cache(url_map_name, path, host = nil)
          @compute.invalidate_url_map_cache(
            @project, url_map_name,
            ::Google::Apis::ComputeV1::CacheInvalidationRule.new(
              :path => path, :host => host
            )
          )
        end
      end
    end
  end
end
