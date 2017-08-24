module Fog
  module Compute
    class Google
      class SSLCertificates < Fog::Collection
        model Fog::Compute::Google::SSLCertificate

        def get(identity)
          if certificate = service.get_ssl_certificate(identity).body
            new(certificate)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
