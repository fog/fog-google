require "helpers/integration_test_helper"
require "integration/pubsub/pubsub_shared"
require "securerandom"
require "base64"
require "tempfile"

class StorageShared < FogIntegrationTest
  def setup
    @client = Fog::Storage::Google.new
    # Enable retries during the suite. This prevents us from
    # having to manually rate limit our requests.
    ::Google::Apis::RequestOptions.default.retries = 5
    # Ensure any resources we create with test prefixes are removed
    Minitest.after_run do
      delete_test_resources
      ::Google::Apis::RequestOptions.default.retries = 0
    end
  end

  def delete_test_resources
    unless @some_temp_file.nil?
      @some_temp_file.unlink
    end

    buckets_result = @client.list_buckets

    unless buckets_result.items.nil?
      begin
        buckets_result.items
                      .map(&:name)
                      .select { |t| t.start_with?(bucket_prefix) }
                      .each do |t|
          object_result = @client.list_objects(t)
          unless object_result.items.nil?
            object_result.items.each { |object| @client.delete_object(t, object.name) }
          end

          begin
            @client.delete_bucket(t)
          # Given that bucket operations are specifically rate-limited, we handle that
          # by waiting a significant amount of time and trying.
          rescue Google::Apis::RateLimitError
            Fog::Logger.warning("encountered rate limit, backing off")
            sleep(10)
            @client.delete_bucket(t)
          end
        end
      # We ignore errors here as list operations may not represent changes applied recently.
      rescue Google::Apis::Error
        Fog::Logger.warning("ignoring Google Api error during delete_test_resources")
      end
    end
  end

  def bucket_prefix
    "fog-integration-test"
  end

  def object_prefix
    "fog-integration-test-object"
  end

  def new_bucket_name
    "#{bucket_prefix}-#{SecureRandom.uuid}"
  end

  def new_object_name
    "#{object_prefix}-#{SecureRandom.uuid}"
  end

  def some_bucket_name
    # create lazily to speed tests up
    @some_bucket ||= new_bucket_name.tap do |t|
      @client.put_bucket(t)
    end
  end

  def some_object_name
    # create lazily to speed tests up
    @some_object ||= new_object_name.tap do |t|
      @client.put_object(some_bucket_name, t, some_temp_file)
    end
  end

  def temp_file_content
    "hello world"
  end

  def binary_file_content
    "PK\x03\x04\x14\x00\x00\x00\b\x00\x18\x89\x8AM\xE7!\xB7\x1C\x1C\x15j\x00\xB4\xB9".force_encoding(Encoding::ASCII_8BIT)
  end

  def some_temp_file(content = temp_file_content)
    @some_temp_file ||= Tempfile.new("fog-google-storage").tap do |t|
      t.binmode
      t.write(content)
      t.close
    end
    File.open(@some_temp_file.path, "r")
  end
end
