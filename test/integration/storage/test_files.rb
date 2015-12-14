require "helpers/integration_test_helper"

class TestFiles < FogIntegrationTest
  begin
    client_email = Fog.credentials[:google_client_email]
    @@connection = Fog::Google::StorageJSON.new
    @@connection.put_bucket("fog-smoke-test", options = { "acl" => [{ entity: "user-" + client_email, role: "OWNER" }] })
    @@connection.put_bucket_acl("fog-smoke-test", { entity: "allUsers", role: "READER" })
  rescue Exception => e
    puts e
    puts e.backtrace
  end

  begin
    @@directory = @@connection.directories.get("fog-smoke-test")
    @@connection.put_object("fog-smoke-test", "fog-testfile", "THISISATESTFILE")
    @@file = @@directory.files.get("fog-testfile")
  rescue Exception => e
    puts e
    puts e.backtrace
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
    get_file = @directory.files.get("fog-testfile")
    assert_instance_of Fog::Google::StorageJSON::File, get_file
    assert_equal "THISISATESTFILE", get_file.body
  end

  def test_get_https_url
    https_url = @directory.files.get_https_url("fog-testfile")
    assert_match /https/, https_url
    assert_match /fog-smoke-test/, https_url
    assert_match /fog-testfile/, https_url
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
    assert_equal "THISISATESTFILE", @file.body
  end

  def test_set_body
    new_body = "FILEBODYCHANGED"
    @file.body = new_body
    assert_equal new_body, @file.body
    @file.save
    file_get = @directory.files.get("fog-testfile")
    assert_instance_of Fog::Google::StorageJSON::File, file_get
    assert_equal new_body, file_get.body
    file_get.body = "THISISATESTFILE"
    file_get.save
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

  def test_set_metadata
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