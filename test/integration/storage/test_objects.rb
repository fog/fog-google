require "helpers/integration_test_helper"

class TestObjects < FogIntegrationTest
  def setup
    @connection = Fog::Google::StorageJSON.new

    begin
      @connection.put_bucket("fog-smoke-test", options={ 'x-goog-acl' => 'publicReadWrite' })
    rescue
    end
  end

  def teardown
    begin
      @connection.delete_object("fog-smoke-test", "my file")
    rescue
    end
    begin
      @connection.delete_object("fog-smoke-test", "my file copy")
    rescue
    end
    begin
      @connection.delete_bucket("fog-smoke-test")
    rescue
    end
  end

  def test_put_object
    response = @connection.put_object("fog-smoke-test", "my file", "THISISATESTFILE")
    assert_equal response.status, 200
  end

  def test_put_object_acl
    skip
  end

  def test_put_object_url
    skip
  end

  def test_copy_object
    response = @connection.put_object("fog-smoke-test", "my file", "THISISATESTFILE")
    assert_equal response.status, 200
    response = @connection.copy_object("fog-smoke-test", "my file", "fog-smoke-test", "my file copy")
    assert_equal response.status, 200
  end

  def test_delete_object
    response = @connection.put_object("fog-smoke-test", "my file", "THISISATESTFILE")
    assert_equal response.status, 200
    response = @connection.delete_object("fog-smoke-test", "my file")
    assert_equal response.status, 204
  end

  def test_get_object
    skip
  end

  def test_get_object_acl
    skip
  end

  def test_get_object_http_url
    skip
  end

  def test_get_object_https_url
    skip
  end

  def test_get_object_url
    skip
  end

  def test_get_object_torrent
    skip
  end

  def test_head_object
    skip
  end
end