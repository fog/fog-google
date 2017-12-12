module Fog
  module Compute
    class Google
      class Mock
        def delete_http_health_check(_check_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_http_health_check(check_name)
          @compute.delete_http_health_check(@project, check_name)
        end
      end
    end
  end
end
