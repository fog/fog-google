module Fog
  module Compute
    class Google
      class TargetHttpsProxy < Fog::Model
        identity :name

        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :description, :aliases => "description"
        attribute :id, :aliases => "id"
        attribute :kind, :aliases => "kind"
        attribute :self_link, :aliases => "selfLink"
        attribute :url_map, :aliases => "urlMap"
        attribute :ssl_certificates, :aliases => "sslCertificates"

        def save
          requires :identity, :url_map, :ssl_certificates

          data = service.insert_target_https_proxy(
            identity,
            :description => description,
            :url_map => url_map,
            :ssl_certificates => ssl_certificates
          )
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async = true)
          requires :identity

          data = service.delete_target_https_proxy(identity)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { ready? } unless async
          operation
        end

        def set_url_map(url_map, async = true)
          requires :identity

          data = service.set_target_https_proxy_url_map(
            identity, url_map
          )
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { ready? } unless async
          reload
        end

        def set_ssl_certificates(ssl_certificates, async = true)
          requires :identity

          data = service.set_target_https_proxy_ssl_certificates(
            identity, ssl_certificates
          )
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name)
          operation.wait_for { ready? } unless async
          reload
        end

        def ready?
          requires :identity

          service.get_target_https_proxy(identity)
          true
        rescue Fog::Errors::NotFound
          false
        end

        def reload
          requires :identity

          return unless data = begin
            collection.get(identity)
          rescue Excon::Errors::SocketError
            nil
          end

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end

        RUNNING_STATE = "READY".freeze
      end
    end
  end
end
