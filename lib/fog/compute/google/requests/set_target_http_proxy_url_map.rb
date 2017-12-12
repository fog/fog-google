module Fog
  module Compute
    class Google
      class Mock
        def set_target_http_proxy_url_map(_proxy_name, _url_map)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_target_http_proxy_url_map(proxy_name, url_map)
          @compute.set_target_http_proxy_url_map(
            @project, proxy_name,
            ::Google::Apis::ComputeV1::UrlMapReference.new(
              :url_map => url_map.class == String ? url_map : url_map.self_link
            )
          )
        end
      end
    end
  end
end
