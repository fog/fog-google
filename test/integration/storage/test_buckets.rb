require "helpers/integration_test_helper"
require "integration/storage/storage_shared"
require "securerandom"
require "base64"
require "tempfile"

class TestStorageRequests < StorageShared
  def test_put_bucket
    bucket_name = new_bucket_name
    bucket = @client.put_bucket(bucket_name)

    assert_equal(bucket.name, bucket_name)
  end

  # We cannot test the state of the ACL as there are two cases to consider
  # * The authenticated service account has Owner permisions, which allows
  # it to read the ACLs after the predefined ACL is applied.
  # * The authenticated service account does not have Owner  permissions,
  # then, we cannot read the ACLs after the predefined ACL is applied.
  #
  # As we cannot control the service account used for testing, we'll
  # just ensure that a valid operation succeeds and an invalid operation fails.
  def test_put_bucket_predefined_acl
    @client.put_bucket(new_bucket_name, :predefined_acl => "publicRead")
  end

  def test_put_bucket_invalid_predefined_acl
    assert_raises(Google::Apis::ClientError) do
      @client.put_bucket(new_bucket_name, :predefined_acl => "invalidAcl")
    end
  end

  def test_get_bucket
    bucket = @client.get_bucket(some_bucket_name)
    assert_equal(bucket.name, some_bucket_name)
  end

  def test_delete_bucket
    # Create a new bucket to delete it
    bucket_to_delete = new_bucket_name
    @client.put_bucket(bucket_to_delete)

    @client.delete_bucket(bucket_to_delete)

    assert_raises(Google::Apis::ClientError) do
      @client.get_bucket(bucket_to_delete)
    end
  end

  def test_list_buckets
    # Create a new bucket to ensure at least one exists to find
    bucket_name = new_bucket_name
    @client.put_bucket(bucket_name)

    result = @client.list_buckets
    if result.items.nil?
      raise StandardError.new("no buckets found")
    end

    contained = result.items.any? { |bucket| bucket.name == bucket_name }
    assert_equal(true, contained, "expected bucket not present")
  end

  def test_put_bucket_acl
    bucket_name = new_bucket_name
    @client.put_bucket(bucket_name)

    acl = {
      :entity => "allUsers",
      :role => "READER"
    }
    @client.put_bucket_acl(bucket_name, acl)
  end

  def test_list_bucket_acl
    bucket_name = new_bucket_name
    @client.put_bucket(bucket_name)

    acl = {
      :entity => "allUsers",
      :role => "READER"
    }
    @client.put_bucket_acl(bucket_name, acl)

    result = @client.list_bucket_acl(bucket_name)
    if result.items.nil?
      raise StandardError.new("no bucket access controls found")
    end

    contained = result.items.any? do |control|
      control.entity == acl[:entity] && control.role == acl[:role]
    end
    assert_equal(true, contained, "expected bucket access control not present")
  end

  def test_get_bucket_acl
    bucket_name = new_bucket_name
    @client.put_bucket(bucket_name)

    acl = {
      :entity => "allUsers",
      :role => "READER"
    }
    @client.put_bucket_acl(bucket_name, acl)
    result = @client.get_bucket_acl(bucket_name, "allUsers")
    if result.nil?
      raise StandardError.new("no bucket access control found")
    end

    assert_equal(result.role, acl[:role], "incorrect bucket access control role")
  end
end
