require "helpers/integration_test_helper"

class TestFiles < FogIntegrationTest
  begin
    client_email = Fog.credentials[:google_client_email]
    @@connection = Fog::Google::StorageJSON.new
    @@connection.put_bucket("fog-smoke-test", options = { "acl" => [{ entity: "user-" + client_email, role: "OWNER" }] })
    @@connection.put_bucket_acl("fog-smoke-test", { entity: "allUsers", role: "READER" })
  rescue Exception => e
    puts e
  end

  begin
    @@directory = @@connection.directories.get("fog-smoke-test")
    @@file = @@connection.put_object("fog-smoke-test", "fog-testfile", "THISISATESTFILE")
  rescue Exception => e
    puts e
  end

  Minitest.after_run do
    begin
      @connection = Fog::Google::StorageJSON.new
      @connection.delete_object("fog-smoke-test", "fog-testfile")
      @connection.delete_bucket("fog-smoke-test")
    rescue Exception => e
      puts e
    end
  end

  def setup
    @connection = @@connection
    @directory = @@directory
    @file = @@file
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
    copied_file = @file.copy("fog-smoke-test", "fog-testfile-copy")
    assert_instance_of Fog::Google::StorageJSON::File, copied_file
    assert copied_file.destroy
  end

  def test_create_destroy
    testfile = @directory.files.create(key: "fog-testfile-create-destroy")
    assert_instance_of Fog::Google::StorageJSON::File, testfile
    assert testfile.destroy
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