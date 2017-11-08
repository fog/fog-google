module Fog
  module Compute
    class Google
      class Mock
        def get_ssl_certificate(_certificate_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_ssl_certificate(certificate_name)
          @compute.get_ssl_certificate(@project, certificate_name)
        end
      end
    end
  end
end
