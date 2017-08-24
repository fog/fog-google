module Fog
  module Compute
    class Google
      class SSLCerficates < Fog::Collection
        model Fog::Compute::Google::SSLCertificate
      end
    end
  end
end
