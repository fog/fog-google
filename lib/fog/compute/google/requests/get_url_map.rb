module Fog
  module Compute
    class Google
      class Mock
        def get_url_map(_url_map_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_url_map(url_map_name)
          @compute.get_url_map(@project, url_map_name)
        end
      end
    end
  end
end
