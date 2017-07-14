module Fog
  module Storage
    class GoogleJSON
      class Real
        # Get access control list for an Google Storage bucket
        # https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls/list
        #
        # @param bucket_name [String] Name of bucket object is in
        # @return [Google::Apis::StorageV1::BucketAccessControls]
        def get_bucket_acl(bucket_name)
          raise ArgumentError.new("bucket_name is required") unless bucket_name

          @storage_json.list_bucket_access_controls(bucket_name)
        end
      end

      class Mock
        def get_bucket_acl(bucket_name)
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
