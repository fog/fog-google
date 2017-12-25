require "helpers/integration_test_helper"
require "integration/storage/storage_shared"
require "securerandom"
require "base64"
require "tempfile"

class TestStorageRequests < StorageShared
  def test_directories_put
    dir_name = new_bucket_name
    directory = @client.directories.create(:key => dir_name)
    assert_equal(directory.key, dir_name)
  end

  def test_directories_put_predefined_acl
    @client.directories.create(
      :key => new_bucket_name,
      :predefined_acl => "publicRead"
    )
  end

  def test_directories_put_invalid_predefined_acl
    assert_raises(Google::Apis::ClientError) do
      @client.directories.create(
        :key => new_bucket_name,
        :predefined_acl => "invalidAcl"
      )
    end
  end

  def test_directories_get
    directory = @client.directories.get(some_bucket_name)
    assert_equal(directory.key, some_bucket_name)
  end

  def test_directory_files
    file = @client.directories.get(some_bucket_name).files.get(some_object_name)
    assert_equal(some_object_name, file.key)
  end

  def test_directory_public_url
    url = @client.directories.get(some_bucket_name).public_url
    assert_match(/storage.googleapis.com/, url)
  end

  def test_directories_destroy
    dir_name = new_bucket_name
    @client.directories.create(:key => dir_name)

    @client.directories.destroy(dir_name)

    assert_nil(@client.directories.get(dir_name))
  end

  def test_directories_all
    dir_name = new_bucket_name
    @client.directories.create(:key => dir_name)

    result = @client.directories.all
    if result.nil?
      raise StandardError.new("no directories found")
    end

    unless result.any? { |directory| directory.key == dir_name }
      raise StandardError.new("failed to find expected directory")
    end
  end
end
