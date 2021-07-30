module Fog
  module Storage
    class GoogleJSON
      class Real
        # Create a Google Storage bucket
        # @see https://cloud.google.com/storage/docs/json_api/v1/buckets/insert
        #
        # @param bucket_name [String] Name of bucket to create
        # @param options [Hash]
        #   Optional fields. Acceptable options include
        #   any writeable bucket attribute (see docs)
        #   or one of the following options:
        # @param predefined_acl [String] Applies a predefined set of access controls to this bucket.
        # @param predefined_default_object_acl [String] Applies a predefined set of default object access controls
        #
        # @return [Google::Apis::StorageV1::Bucket]
        def put_bucket(bucket_name,
                       predefined_acl: nil,
                       predefined_default_object_acl: nil,
                       # **options.transform_keys(&:to_sym) is needed so paperclip doesn't break on Ruby 2.6
                       # TODO(temikus): remove this once Ruby 2.6 is deprecated for good
                       **options.transform_keys(&:to_sym))
          bucket = ::Google::Apis::StorageV1::Bucket.new(
            **options.transform_keys(&:to_sym).merge(:name => bucket_name)
          )

          @storage_json.insert_bucket(
            @project, bucket,
            :predefined_acl => predefined_acl,
            :predefined_default_object_acl => predefined_default_object_acl
          )
        end
      end

      class Mock
        def put_bucket(_bucket_name, _options = {})
          # :no-coverage:
          Fog::Mock.not_implemented
          # :no-coverage:
        end
      end
    end
  end
end
