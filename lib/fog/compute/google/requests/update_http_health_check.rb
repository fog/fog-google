module Fog
  module Compute
    class Google
      class Mock
        def update_http_health_check(_check_name, _opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def update_http_health_check(check_name, opts = {})
          @compute.update_http_health_check(
            @project,
            check_name,
            ::Google::Apis::ComputeV1::HttpHealthCheck.new(
              opts.merge(:name => check_name)
            )
          )
        end
      end
    end
  end
end
