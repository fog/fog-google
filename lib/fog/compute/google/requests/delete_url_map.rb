module Fog
  module Compute
    class Google
      class Mock
        def delete_url_map(_url_map_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_url_map(url_map_name)
          @compute.delete_url_map(@project, url_map_name)
        end
      end
    end
  end
end
