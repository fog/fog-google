require "helpers/integration_test_helper"
require "integration/factories/sql_v1_certs_factory"

class TestSQLV1Certs < FogIntegrationTest
  # This test doesn't include TestCollection as certs are not an independent resource.

  def setup
    @subject = Fog::Google[:sql].ssl_certs
    @factory = SqlV1CertsFactory.new(namespaced_name)
    @client  = Fog::Google::SQL.new
  end

  def teardown
    @factory.cleanup
  end

  def test_ssl_certs
    # Create an instance and an SSL cert
    ssl_cert = @factory.create
    instance_name = ssl_cert.instance

    # Create a second cert and attach to the same instance
    ssl_cert2 = @subject.new(:common_name => "#{ssl_cert.common_name}-2",
                             :instance => instance_name)
    ssl_cert2.save

    # Verify it can be retrieved
    @subject.get(instance_name, ssl_cert2.sha1_fingerprint).tap do |result|
      assert_equal(ssl_cert2.common_name, result.common_name)
      assert_equal("sql#sslCert", result.kind)
    end

    # Verify instance returns 2 certs
    list_result = @subject.all(instance_name)
    assert_equal(2, list_result.size,
                 "expected 2 SSL certs")

    # Delete one cert
    ssl_cert2.destroy(:async => false)
    list_result = @subject.all(instance_name)
    assert_equal(1, list_result.size,
                 "expected one less SSL cert after deletion")

    # Test if SSL config is reset correctly
    instance = @client.instances.get(instance_name)
    instance.reset_ssl_config(:async => false)
    assert_equal(0, @subject.all(instance_name).size,
                 "expected no SSL certs after reset")
  end
end
