module Fog
  module Compute
    class Google
      class Mock
        def insert_http_health_check(_check_name, _options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_http_health_check(check_name, opts = {})
          @compute.insert_http_health_check(
            @project,
            ::Google::Apis::ComputeV1::HttpHealthCheck.new(
              opts.merge(:name => check_name)
            )
          )
        end
      end
    end
  end
end
