module Fog
  module Compute
    class Google
      class Mock
        def insert_backend_service(_backend_service_name, _opts = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_backend_service(backend_service_name, opts = {})
          options = opts.reject { |_k, v| v.nil? }
                        .merge(:name => backend_service_name)

          be_service = ::Google::Apis::ComputeV1::BackendService.new(options)
          @compute.insert_backend_service(@project, be_service)
        end
      end
    end
  end
end
