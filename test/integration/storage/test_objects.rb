require "helpers/integration_test_helper"
require "integration/storage/storage_shared"
require "securerandom"
require "base64"
require "tempfile"

class TestStorageRequests < StorageShared
  def test_put_object
    sleep(1)

    object_name = new_object_name
    object = @client.put_object(some_bucket_name, object_name, some_temp_file_name)
    assert_equal(object_name, object.name)
  end

  def test_put_object_predefined_acl
    @client.put_object(some_bucket_name, new_object_name, some_temp_file_name,
                       "predefinedAcl" => "publicRead")
  end

  def test_put_object_invalid_predefined_acl
    assert_raises(Google::Apis::ClientError) do
      @client.put_object(some_bucket_name, new_object_name, some_temp_file_name,
                         "predefinedAcl" => "invalidAcl")
    end
  end

  def test_get_object
    sleep(1)

    object = @client.get_object(some_bucket_name, some_object_name)
    assert_equal(temp_file_content, object[:body])
  end

  def test_delete_object
    sleep(1)

    object_name = new_object_name
    @client.put_object(some_bucket_name, object_name, some_temp_file_name)
    @client.delete_object(some_bucket_name, object_name)

    assert_raises(Google::Apis::ClientError) do
      @client.get_object(some_bucket_name, object_name)
    end
  end

  def test_head_object
    sleep(1)

    object = @client.head_object(some_bucket_name, some_object_name)
    assert_equal(temp_file_content.length, object.size)
    assert_equal(some_bucket_name, object.bucket)
  end

  def test_copy_object
    sleep(1)

    target_object_name = new_object_name

    @client.copy_object(some_bucket_name, some_object_name,
                        some_bucket_name, target_object_name)
    object = @client.get_object(some_bucket_name, target_object_name)
    assert_equal(temp_file_content, object[:body])
  end

  def test_list_objects
    sleep(1)

    expected_object = some_object_name

    result = @client.list_objects(some_bucket_name)
    if result.items.nil?
      raise StandardError.new("no objects found")
    end

    contained = result.items.any? { |object| object.name == expected_object }
    assert_equal(true, contained, "expected object not present")
  end

  def test_put_object_acl
    sleep(1)

    object_name = new_object_name
    @client.put_object(some_bucket_name, object_name, some_temp_file_name)

    acl = {
      :entity => "allUsers",
      :role => "READER"
    }
    @client.put_object_acl(some_bucket_name, object_name, acl)
  end

  def test_get_object_acl
    sleep(1)

    object_name = new_object_name
    @client.put_object(some_bucket_name, object_name, some_temp_file_name)

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
