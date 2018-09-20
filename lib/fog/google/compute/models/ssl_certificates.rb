module Fog
  module Google
    class Compute
      class SslCertificates < Fog::Collection
        model Fog::Google::Compute::SslCertificate

        def get(certificate_name)
          if certificate = service.get_ssl_certificate(certificate_name)
            new(certificate.to_h)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end

        def all(_filters = {})
          data = service.list_ssl_certificates.to_h[:items] || []
          load(data)
        end
      end
    end
  end
end
