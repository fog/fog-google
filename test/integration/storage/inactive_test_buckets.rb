require "helpers/integration_test_helper"

class TestBuckets < FogIntegrationTest
  begin
    @@connection = Fog::Storage::Google.new
    @@connection.delete_bucket("fog-smoke-test")
  rescue Exception => e
    # puts e
  end

  def setup
    @connection = @@connection
  end

  def teardown
    @connection.delete_bucket("fog-smoke-test")
  rescue
  end

  def test_put_bucket
    response = @connection.put_bucket("fog-smoke-test")
    assert_equal response.status, 200
  end

  def test_put_bucket_acl
    response = @connection.put_bucket("fog-smoke-test", options: { "x-goog-acl" => "publicReadWrite" })
    assert_equal response.status, 200
    acl = { :entity => "domain-google.com",
            :role => "READER" }
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
    response = @connection.put_bucket("fog-smoke-test",
                                      options: { "acl" => [{ :entity => "user-fake@developer.gserviceaccount.com", :role => "OWNER" }] })
    assert_equal response.status, 200
    response = @connection.get_bucket_acl("fog-smoke-test")
    assert_equal response.status, 200
  end
end
