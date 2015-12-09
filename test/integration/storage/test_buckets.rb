require "helpers/integration_test_helper"

class TestBuckets < FogIntegrationTest
  def setup
    @connection = Fog::Google::StorageJSON.new
  end

  def teardown
    begin
      @connection.delete_bucket("fog-smoke-test")
    rescue
    end
  end

  def test_put_bucket
    response = @connection.put_bucket("fog-smoke-test")
    assert_equal response.status, 200
  end

  def test_put_bucket_acl
    response = @connection.put_bucket("fog-smoke-test", options={ 'x-goog-acl' => 'publicReadWrite' })
    assert_equal response.status, 200
    acl = { entity: 'domain-example.com',
            role: 'READER' }
    response = @connection.put_bucket_acl("fog-smoke-test", acl)
    assert_equal response.status, 200
  end

  def test_delete_bucket
    response = @connection.put_bucket("fog-smoke-test")
    assert_equal response.status, 200
    response = @connection.delete_bucket("fog-smoke-test")
    assert_equal response.status, 204
  end

  def test_get_bucket
    response = @connection.put_bucket("fog-smoke-test")
    assert_equal response.status, 200
    response = @connection.get_bucket("fog-smoke-test")
    assert_equal response.status, 200
  end

  def test_get_bucket_acl
    client_email = Fog.credentials[:google_client_email]
    response = @connection.put_bucket("fog-smoke-test", 
      options={ 'acl' => [{ entity: 'user-'+client_email, role: 'OWNER' }] })
    assert_equal response.status, 200
    response = @connection.get_bucket_acl("fog-smoke-test")
    assert_equal response.status, 200
  end
end