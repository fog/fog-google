module Fog
  module Compute
    class Google
      class Mock
        def get_url_map(name)
          url_map = data[:url_maps][name]
          return nil if url_map.nil?
          build_excon_response(url_map)
        end
      end

      class Real
        def get_url_map(name)
          api_method = @compute.url_maps.get
          parameters = {
            "project" => @project,
            "urlMap" => name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
