require "helpers/integration_test_helper"

class TestBuckets < FogIntegrationTest
  def setup
    # Uncomment this if you want to make real requests to GCE (you _will_ be billed!)
    # WebMock.disable!

    @connection = Fog::Google::StorageJSON.new
    # @subject = Fog::Compute[:google].target_instances
    # @factory = TargetInstancesFactory.new(namespaced_name)
  end

  def teardown
    begin
      @connection.delete_bucket("fog-smoke-test")
    rescue
    end
  end

  def test_put_bucket
    response = @connection.put_bucket("fog-smoke-test", options={ 'x-goog-acl' => 'publicReadWrite' })
    assert_equal response.status, 200
  end

  def test_put_bucket_acl
    skip
  end

  def test_delete_bucket
    response = @connection.put_bucket("fog-smoke-test", options={ 'x-goog-acl' => 'publicReadWrite' })
    assert_equal response.status, 200
    response = @connection.delete_bucket("fog-smoke-test")
    assert_equal response.status, 204
  end

  def test_get_bucket
    response = @connection.put_bucket("fog-smoke-test", options={ 'x-goog-acl' => 'publicReadWrite' })
    assert_equal response.status, 200
    response = @connection.get_bucket("fog-smoke-test")
    assert_equal response.status, 200
  end

  def test_get_bucket_acl
    skip
  end
end