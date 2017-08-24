module Fog
  module Compute
    class Google
      class Mock
        def delete_ssl_certificate(certificate_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_ssl_certificate(certificate_name)

          api_method = @compute.ssl_certificate.delete
          parameters = {
            "project"    => @project,
            "sslCertificate"     => certificate_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
