module Fog
  module Storage
    class GoogleJSON
      class Real
        # Get access control list for an Google Storage object
        # https://cloud.google.com/storage/docs/json_api/v1/objectAccessControls/get
        #
        # @param bucket_name [String] Name of bucket object is in
        # @param object_name [String] Name of object to add ACL to
        # @param options [Hash] Optional hash of options
        # @option options [String] "versionId" specify a particular version to retrieve
        # @return [Google::Apis::StorageV1::ObjectAccessControls]
        def get_object_acl(bucket_name, object_name, options = {})
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          raise ArgumentError.new("object_name is required") unless object_name

          @storage_json.list_object_access_controls(bucket_name, object_name,
                                                    :generation => options["versionId"])
        end
      end

      class Mock
        def get_object_acl(bucket_name, object_name)
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
