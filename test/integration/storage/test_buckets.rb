require "helpers/integration_test_helper"
require "integration/storage/storage_shared"
require "securerandom"
require "base64"
require "tempfile"

class TestStorageRequests < StorageShared
  def test_put_bucket
    sleep(1)

    bucket_name = new_bucket_name
    bucket = @client.put_bucket(bucket_name)

    assert_equal(bucket.name, bucket_name)
  end

  def test_get_bucket
    sleep(1)

    bucket = @client.get_bucket(some_bucket_name)
    assert_equal(bucket.name, some_bucket_name)
  end

  def test_delete_bucket
    sleep(1)

    # Create a new bucket to delete it
    bucket_to_delete = new_bucket_name
    @client.put_bucket(bucket_to_delete)

    @client.delete_bucket(bucket_to_delete)

    assert_raises(Google::Apis::ClientError) do
      @client.get_bucket(bucket_to_delete)
    end
  end

  def test_list_buckets
    sleep(1)

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
    sleep(1)

    bucket_name = new_bucket_name
    @client.put_bucket(bucket_name)

    acl = {
      :entity => "allUsers",
      :role => "READER"
    }
    @client.put_bucket_acl(bucket_name, acl)
  end

  def test_get_bucket_acl
    sleep(1)

    bucket_name = new_bucket_name
    @client.put_bucket(bucket_name)

    acl = {
      :entity => "allUsers",
      :role => "READER"
    }
    @client.put_bucket_acl(bucket_name, acl)

    result = @client.get_bucket_acl(bucket_name)
    if result.items.nil?
      raise StandardError.new("no bucket access controls found")
    end

    contained = result.items.any? do |control|
      control.entity == acl[:entity] && control.role == acl[:role]
    end
    assert_equal(true, contained, "expected bucket access control not present")
  end
end
