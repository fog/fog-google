module Fog
  module Compute
    class Google
      class Mock
        def set_target_https_proxy_ssl_certificates(_proxy_name, _certs)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_target_https_proxy_ssl_certificates(proxy_name, certs)
          @compute.set_target_https_proxy_ssl_certificates(
            @project, proxy_name,
            ::Google::Apis::ComputeV1::TargetHttpsProxiesSetSslCertificatesRequest.new(
              :ssl_certificates => certs
            )
          )
        end
      end
    end
  end
end
