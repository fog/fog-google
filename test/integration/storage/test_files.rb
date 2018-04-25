require "helpers/integration_test_helper"
require "integration/storage/storage_shared"
require "securerandom"
require "base64"
require "tempfile"

class TestStorageRequests < StorageShared
  def test_files_create_file
    file_name = new_object_name
    @client.directories.get(some_bucket_name).files.create(
      :key => file_name,
      :body => some_temp_file
    )

    object = @client.get_object(some_bucket_name, file_name)
    assert_equal(object[:body], temp_file_content)
  end

  def test_files_create_string
    expected_body = "A file body"
    file_name = new_object_name
    @client.directories.get(some_bucket_name).files.create(
      :key => file_name,
      :body => expected_body
    )

    object = @client.get_object(some_bucket_name, file_name)
    assert_equal(object[:body], expected_body)
  end

  def test_files_create_predefined_acl
    @client.directories.get(some_bucket_name).files.create(
      :key => new_object_name,
      :body => some_temp_file,
      :predefined_acl => "publicRead"
    )
  end

  def test_files_create_invalid_predefined_acl
    assert_raises(ArgumentError) do
      @client.directories.get(some_bucket_name).files.create(
        :key => new_object_name,
        :body => some_temp_file,
        :predefined_acl => "invalidAcl"
      )
    end
  end

  def test_files_get
    content = @client.directories.get(some_bucket_name).files.get(some_object_name)
    assert_equal(content.body, temp_file_content)
  end

  def test_files_set_body_string
    file_name = new_object_name
    directory = @client.directories.get(some_bucket_name)
    file = directory.files.create(
      :key => file_name,
      :body => temp_file_content
    )

    assert_equal(file.body, temp_file_content)

    new_body = "Changed file body"
    file.body = new_body
    file.save

    updated_file = directory.files.get(file_name)
    assert_equal(updated_file.body, new_body)
  end

  def test_files_set_body_file
    file_name = new_object_name
    directory = @client.directories.get(some_bucket_name)
    file = directory.files.create(
      :key => file_name,
      :body => some_temp_file
    )

    new_body = "Changed file body"
    file.body = new_body
    file.save

    updated_file = directory.files.get(file_name)
    assert_equal(updated_file.body, new_body)
  end

  def test_files_metadata
    content = @client.directories.get(some_bucket_name).files.metadata(some_object_name)
    assert_equal(content.content_length, temp_file_content.length)
    assert_equal(content.key, some_object_name)
  end

  def test_files_destroy
    file_name = new_object_name
    @client.directories.get(some_bucket_name).files.create(
      :key => file_name,
      :body => some_temp_file
    )

    @client.directories.get(some_bucket_name).files.destroy(file_name)

    assert_nil(@client.directories.get(some_bucket_name).files.get(file_name))
  end

  def test_files_all
    file_name = new_object_name
    @client.directories.get(some_bucket_name).files.create(
      :key => file_name,
      :body => some_temp_file
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
      :body => some_temp_file
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
    target_object_name = new_object_name
    @client.directories.get(some_bucket_name).files.get(some_object_name).copy(some_bucket_name,
                                                                               target_object_name)

    content = @client.directories.get(some_bucket_name).files.get(target_object_name)
    assert_equal(content.body, temp_file_content)
  end

  def test_files_public_url
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

  def test_files_get_https_url_whitespace
    directory = @client.directories.get(some_bucket_name)
    https_url = directory.files.get_https_url("fog -testfile", (Time.now + 60).to_i)
    assert_match(/https/, https_url)
    assert_match(/#{bucket_prefix}/, https_url)
    assert_match(/fog\%20-testfile/, https_url)
  end
end
