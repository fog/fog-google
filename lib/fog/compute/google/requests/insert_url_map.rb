module Fog
  module Compute
    class Google
      class Mock
        def insert_url_map(_url_map_name, _url_map = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_url_map(url_map_name, url_map = {})
          url_map[:host_rules] = url_map[:host_rules] || []
          url_map[:path_matchers] = url_map[:path_matchers] || []
          url_map[:tests] = url_map[:tests] || []

          url_map_obj = ::Google::Apis::ComputeV1::UrlMap.new(
            url_map.merge(:name => url_map_name)
          )
          @compute.insert_url_map(@project, url_map_obj)
        end
      end
    end
  end
end
