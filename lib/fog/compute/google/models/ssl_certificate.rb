module Fog
  module Compute
    class Google
      ##
      # Represents a Subnetwork resource
      #
      # @see https://cloud.google.com/compute/docs/reference/latest/sslCertificates
      class SslCertificate < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :description
        attribute :self_link, :aliases => "selfLink"
        attribute :certificate
        attribute :private_key, :aliases => "privateKey"

        def save
          requires :identity, :certificate, :private_key
          data = service.insert_ssl_certificate(
            identity, certificate, private_key,
            :description => description
          )
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async = true)
          requires :identity
          data = service.delete_ssl_certificate(identity)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { ready? } unless async
          operation
        end
      end
    end
  end
end
