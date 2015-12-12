require "helpers/integration_test_helper"

class TestDirectories < FogIntegrationTest
  begin
    client_email = Fog.credentials[:google_client_email]
    @@connection = Fog::Google::StorageJSON.new
    @@connection.put_bucket("fog-smoke-test", options = { "acl" => [{ entity: "user-" + client_email, role: "OWNER" }] })
    @@connection.put_bucket_acl("fog-smoke-test", { entity: "allUsers", role: "READER" })
    @@directory = @@connection.directories.get("fog-smoke-test")
  rescue Exception => e
    puts e
  end

  Minitest.after_run do
    begin
      @connection = Fog::Google::StorageJSON.new
      @connection.delete_bucket("fog-smoke-test")
    rescue Exception => e
      puts e
    end
  end

  def setup
    @connection = @@connection
    @directory = @@directory
  end

  def test_all_directories
    skip
  end

  def test_get_directory
    directory_get = @connection.directories.get("fog-smoke-test")
    assert_instance_of Fog::Google::StorageJSON::Directory, directory_get
  end

  def test_create_destroy_directory
    directory_create = @connection.directories.create(key: "fog-smoke-test-create-destroy")
    assert_instance_of Fog::Google::StorageJSON::Directory, directory_create
    assert directory_create.destroy
  end

  def test_public_url
    public_url = @directory.public_url
    assert_match /storage\.googleapis\.com/, public_url
    assert_match /fog-smoke-test/, public_url
  end

  def test_public
    skip
  end

  def test_files
    skip
  end

  def test_acl
    skip
  end
end