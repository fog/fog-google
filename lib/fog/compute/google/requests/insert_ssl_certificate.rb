module Fog
  module Compute
    class Google
      class Mock
        def insert_ssl_certificate(_certificate_name, _certificate, _private_key, _options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_ssl_certificate(certificate_name, certificate, private_key, options = {})
          api_method = @compute.ssl_certificates.insert
          parameters = {
            'project' => @project
          }
          body_object = {
            'certificate' => certificate,
            'name'        => certificate_name,
            'privateKey'  => private_key
          }

          body_object['description'] = options[:description] if options[:description]

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
