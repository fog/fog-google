require "helpers/integration_test_helper"

class TestFiles < FogIntegrationTest
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

  def test_all_files
    skip
  end

  def test_each_files
    skip
  end

  def test_get
    skip
  end

  def test_get_https_url
    skip
  end

  def test_head
    skip
  end

  def test_new
    skip
  end

  def test_acl
    skip
  end

  def test_body
    skip
  end

  def test_set_body
    skip
  end

  def test_copy
    skip
  end

  def test_create_destroy
    skip
  end

  def test_metadata
    skip
  end

  def test_set_metdata
    skip
  end

  def test_set_owner
    skip
  end

  def test_set_public
    skip
  end

  def test_public_url
    skip
  end

  def test_url
    skip
  end
end