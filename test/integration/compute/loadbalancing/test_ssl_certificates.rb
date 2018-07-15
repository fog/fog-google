require "helpers/integration_test_helper"
require "integration/factories/ssl_certificates_factory"

class TestSslCertificates < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].ssl_certificates
    @factory = SslCertificatesFactory.new(namespaced_name)
  end
end
