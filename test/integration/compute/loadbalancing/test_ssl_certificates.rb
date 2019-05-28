require "helpers/integration_test_helper"
require "integration/factories/ssl_certificates_factory"

class TestSslCertificates < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.ssl_certificates
    @factory = SslCertificatesFactory.new(namespaced_name)
  end
end
