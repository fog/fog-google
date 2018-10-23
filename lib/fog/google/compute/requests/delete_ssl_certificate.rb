module Fog
  module Google
    class Compute
      class Mock
        def delete_ssl_certificate(_certificate_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_ssl_certificate(certificate_name)
          @compute.delete_ssl_certificate(project, certificate_name)
        end
      end
    end
  end
end
