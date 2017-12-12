require "helpers/integration_test_helper"
require "integration/storage/storage_shared"
require "securerandom"
require "base64"
require "tempfile"

class TestStorageRequests < StorageShared
  def test_put_object_string
    object_name = new_object_name
    @client.put_object(some_bucket_name, object_name, some_temp_file)

    object = @client.get_object(some_bucket_name, object_name)

    assert_equal(object_name, object[:name])
    assert_equal(temp_file_content, object[:body])
  end

  def test_put_object_file
    object_name = new_object_name
    expected_body = "A file body"
    @client.put_object(some_bucket_name, object_name, expected_body)

    object = @client.get_object(some_bucket_name, object_name)
    assert_equal(object_name, object[:name])
    assert_equal(expected_body, object[:body])
  end

  def test_put_object_paperclip
    object_name = new_object_name
    paperclip_file = OpenStruct.new(:path => "/tmp/fog-google-storage",
                                    :content_type => "image/png")
    @client.put_object(some_bucket_name, object_name, paperclip_file)

    object = @client.get_object(some_bucket_name, object_name)

    assert_equal(object_name, object[:name])
    assert_equal("image/png", object[:content_type])
  end

  def test_put_object_predefined_acl
    @client.put_object(some_bucket_name, new_object_name, some_temp_file,
                       "predefinedAcl" => "publicRead")
  end

  def test_put_object_invalid_predefined_acl
    assert_raises(Google::Apis::ClientError) do
      @client.put_object(some_bucket_name, new_object_name, some_temp_file,
                         "predefinedAcl" => "invalidAcl")
    end
  end

  def test_get_object
    object = @client.get_object(some_bucket_name, some_object_name)
    assert_equal(temp_file_content, object[:body])
  end

  def test_delete_object
    object_name = new_object_name
    @client.put_object(some_bucket_name, object_name, some_temp_file)
    @client.delete_object(some_bucket_name, object_name)

    assert_raises(Google::Apis::ClientError) do
      @client.get_object(some_bucket_name, object_name)
    end
  end

  def test_head_object
    object = @client.head_object(some_bucket_name, some_object_name)
    assert_equal(temp_file_content.length, object.size)
    assert_equal(some_bucket_name, object.bucket)
  end

  def test_copy_object
    target_object_name = new_object_name

    @client.copy_object(some_bucket_name, some_object_name,
                        some_bucket_name, target_object_name)
    object = @client.get_object(some_bucket_name, target_object_name)
    assert_equal(temp_file_content, object[:body])
  end

  def test_list_objects
    expected_object = some_object_name

    result = @client.list_objects(some_bucket_name)
    if result.items.nil?
      raise StandardError.new("no objects found")
    end

    contained = result.items.any? { |object| object.name == expected_object }
    assert_equal(true, contained, "expected object not present")
  end

  def test_put_object_acl
    object_name = new_object_name
    @client.put_object(some_bucket_name, object_name, some_temp_file)

    acl = {
      :entity => "allUsers",
      :role => "READER"
    }
    @client.put_object_acl(some_bucket_name, object_name, acl)
  end

  def test_get_object_acl
    object_name = new_object_name
    @client.put_object(some_bucket_name, object_name, some_temp_file)

    acl = {
      :entity => "allUsers",
      :role => "READER"
    }
    @client.put_object_acl(some_bucket_name, object_name, acl)

    result = @client.get_object_acl(some_bucket_name, object_name)
    if result.items.nil?
      raise StandardError.new("no object access controls found")
    end

    contained = result.items.any? do |control|
      control.entity == acl[:entity] && control.role == acl[:role]
    end
    assert_equal(true, contained, "expected object access control not present")
  end

  def test_get_object_https_url
    result = @client.get_object_https_url(some_bucket_name, some_object_name, 0)
    assert_operator(result.length, :>, 0)
  end

  def test_get_object_http_url
    result = @client.get_object_http_url(some_bucket_name, some_object_name, 0)
    assert_operator(result.length, :>, 0)
  end

  def test_put_object_url
    result = @client.put_object_url(some_bucket_name, new_object_name, 0)
    assert_operator(result.length, :>, 0)
  end
end
