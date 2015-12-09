require "helpers/integration_test_helper"

def before_run
  begin
    @connection = Fog::Google::StorageJSON.new
    @connection.put_bucket("fog-smoke-test", options={ 'x-goog-acl' => 'publicReadWrite' })
  rescue Exception => e
    puts e
  end
end
before_run

class TestObjects < FogIntegrationTest
  Minitest.after_run do
    puts "after run!"
    begin
      @connection = Fog::Google::StorageJSON.new
      @connection.delete_bucket("fog-smoke-test")
    rescue Exception => e
      puts e
    end
  end

  def setup
    @connection = Fog::Google::StorageJSON.new
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
  end

  def test_put_object
    response = @connection.put_object("fog-smoke-test", "my file", "THISISATESTFILE")
    assert_equal response.status, 200
  end

  def test_put_object_acl
    response = @connection.put_object("fog-smoke-test", "my file", "THISISATESTFILE")
    assert_equal response.status, 200
    acl = { entity: 'domain-example.com',
            role: 'READER' }
    response = @connection.put_object_acl("fog-smoke-test", "my file", acl)
    assert_equal response.status, 200
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