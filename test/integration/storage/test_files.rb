require "helpers/integration_test_helper"
require "integration/storage/storage_shared"
require "securerandom"
require "base64"
require "tempfile"

class TestStorageRequests < StorageShared
  def test_files_create
    sleep(1)

    @client.directories.get(some_bucket_name).files.create(
      :key => new_object_name,
      :body => some_temp_file_name
    )
  end

  def test_files_create_predefined_acl
    @client.directories.get(some_bucket_name).files.create(
      :key => new_object_name,
      :body => some_temp_file_name,
      :predefined_acl => "publicRead"
    )
  end


  def test_files_create_invalid_predefined_acl
    assert_raises(Google::Apis::ClientError) do
      @client.directories.get(some_bucket_name).files.create(
        :key => new_object_name,
        :body => some_temp_file_name,
        :predefined_acl => "invalidAcl"
      )
    end
  end

  def test_files_get
    sleep(1)

    content = @client.directories.get(some_bucket_name).files.get(some_object_name)
    assert_equal(content.body, temp_file_content)
  end

  def test_files_head
    sleep(1)

    content = @client.directories.get(some_bucket_name).files.head(some_object_name)
    assert_equal(content.content_length, temp_file_content.length)
    assert_equal(content.key, some_object_name)
  end

  def test_files_destroy
    sleep(1)

    file_name = new_object_name
    @client.directories.get(some_bucket_name).files.create(
      :key => file_name,
      :body => some_temp_file_name
    )

    @client.directories.get(some_bucket_name).files.destroy(file_name)

    assert_raises(Google::Apis::ClientError) do
      @client.directories.get(some_bucket_name).files.get(file_name)
    end
  end

  def test_files_all
    sleep(1)

    file_name = new_object_name
    @client.directories.get(some_bucket_name).files.create(
      :key => file_name,
      :body => some_temp_file_name
    )

    result = @client.directories.get(some_bucket_name).files.all
    if result.nil?
      raise StandardError.new("no files found")
    end

    unless result.any? { |file| file.key == file_name  }
      raise StandardError.new("failed to find expected file")
    end
  end

  def test_files_each
    file_name = new_object_name
    @client.directories.get(some_bucket_name).files.create(
      :key => file_name,
      :body => some_temp_file_name
    )

    found_file = false
    @client.directories.get(some_bucket_name).files.each do |file|
      if file.key == file_name
        found_file = true
      end
    end
    assert_equal(true, found_file, "failed to find expected file while iterating")
  end

  def test_files_copy
    sleep(1)

    target_object_name = new_object_name
    @client.directories.get(some_bucket_name).files.get(some_object_name).copy(some_bucket_name,
                                                                               target_object_name)

    content = @client.directories.get(some_bucket_name).files.get(target_object_name)
    assert_equal(content.body, temp_file_content)
  end

  def test_files_public_url
    sleep(1)

    url = @client.directories.get(some_bucket_name).files.get(some_object_name).public_url
    assert_match(/storage.googleapis.com/, url)
  end

  def test_files_get_https_url
    directory = @client.directories.get(some_bucket_name)
    https_url = directory.files.get_https_url("fog-testfile", (Time.now + 60).to_i)
    assert_match(/https/, https_url)
    assert_match(/#{bucket_prefix}/, https_url)
    assert_match(/fog-testfile/, https_url)
  end

  def test_url
    skip
  end
end
