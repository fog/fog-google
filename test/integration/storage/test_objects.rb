require "helpers/integration_test_helper"
require "integration/storage/storage_shared"
require "securerandom"
require "base64"
require "tempfile"
require "net/http"

class TestStorageRequests < StorageShared
  def test_put_object_string
    object_name = new_object_name
    @client.put_object(some_bucket_name, object_name, some_temp_file)

    object = @client.get_object(some_bucket_name, object_name)

    assert_equal(object_name, object[:name])
    assert_equal(temp_file_content, object[:body])
  end

  def test_put_object_nil
    assert_raises(ArgumentError) do
      @client.put_object(some_bucket_name, new_object_name, nil)
    end
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
    paperclip_file = OpenStruct.new(:path => some_temp_file(binary_file_content),
                                    :content_type => "image/png")
    @client.put_object(some_bucket_name, object_name, paperclip_file, :content_type => "image/png")

    object = @client.get_object(some_bucket_name, object_name)

    assert_equal(object_name, object[:name])
    assert_equal(Encoding::ASCII_8BIT, object[:body].encoding)
    assert_equal(binary_file_content, object[:body])
    assert_equal("image/png", object[:content_type])
  end

  def test_put_object_contradictory_content_type
    object_name = new_object_name
    file = OpenStruct.new(:path => some_temp_file,
                          :content_type => "text/plain")
    @client.put_object(some_bucket_name, object_name, file, :content_type => "image/png")

    object = @client.get_object(some_bucket_name, object_name)

    assert_equal(object_name, object[:name])
    assert_equal("image/png", object[:content_type])
  end

  def test_put_object_predefined_acl
    @client.put_object(some_bucket_name, new_object_name, some_temp_file,
                       :predefined_acl => "publicRead")
  end

  def test_put_object_invalid_predefined_acl
    assert_raises(Google::Apis::ClientError) do
      @client.put_object(some_bucket_name, new_object_name, some_temp_file,
                         :predefined_acl => "invalidAcl")
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

  def test_object_metadata
    object = @client.get_object_metadata(some_bucket_name, some_object_name)
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

  def test_copy_object_predefined_acl
    target_object_name = new_object_name

    res = @client.copy_object(some_bucket_name, some_object_name,
                              some_bucket_name, target_object_name, destination_predefined_acl: "publicRead")

    result = @client.get_object(some_bucket_name, target_object_name)

    response = Net::HTTP.get_response(URI(result[:self_link]))

    assert_kind_of(Net::HTTPOK, response)
  end

  def test_copy_object_with_request_options
    assert_raises(Google::Apis::AuthorizationError) do
      target_object_name = new_object_name

      @client.copy_object(some_bucket_name, some_object_name,
                          some_bucket_name, target_object_name, authorization: false)
    end
  end

  def test_copy_object_with_object_property
    target_object_name = new_object_name

    @client.copy_object(some_bucket_name, some_object_name,
                        some_bucket_name, target_object_name, content_type: 'text/plain')

    object = @client.get_object(some_bucket_name, target_object_name)

    assert_equal("text/plain", object[:content_type])
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

  def test_list_object_acl
    object_name = new_object_name
    acls = [
      {
        :entity => "allUsers",
        :role => "READER"
      },
      {
        :entity => "allAuthenticatedUsers",
        :role => "READER"
      }
    ]
    @client.put_object(some_bucket_name, object_name, some_temp_file, :acl => acls)

    result = @client.list_object_acl(some_bucket_name, object_name)
    if result.items.nil?
      raise StandardError.new("no object access controls found")
    end

    assert_operator(acls.length, :<=, result.items.length,
                    "expected at least #{acls.length} ACL items")

    expected_acls = Hash[acls.map { |acl| [acl[:entity], acl[:role]] }]
    num_found = 0

    result.items.each do |actual_acl|
      if expected_acls[actual_acl.entity] == actual_acl.role
        num_found += 1
      end
    end

    assert_equal(acls.length, num_found, "only found #{num_found} of #{acls.length} expected ACLs")
  end

  def test_get_object_acl
    object_name = new_object_name
    @client.put_object(some_bucket_name, object_name, some_temp_file)

    data = {
      :entity => "allUsers",
      :role => "READER"
    }
    @client.put_object_acl(some_bucket_name, object_name, data)

    result = @client.get_object_acl(some_bucket_name, object_name, "allUsers")
    if result.nil?
      raise StandardError.new("expected object access control not found")
    end
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
