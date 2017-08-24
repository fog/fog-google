module Fog
  module Compute
    class Google
      class SslCertificates < Fog::Collection
        model Fog::Compute::Google::SslCertificate

        def get(certificate_name)
          if certificate = service.get_ssl_certificate(certificate_name).body
            new(certificate)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
