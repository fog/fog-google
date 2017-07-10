module Fog
  module Storage
    class GoogleJSON
      class Real
        # List information about objects in an Google Storage bucket #
        # https://cloud.google.com/storage/docs/json_api/v1/buckets#resource
        #
        # @param bucket_name [String] Name of bucket to list
        # @param options [Hash] Optional hash of options
        # @option options [String] "ifMetagenerationMatch" Makes the return of the bucket metadata
        #     conditional on whether the bucket's current metageneration matches the
        #     given value.
        # @option options [String] "ifMetagenerationNotMatch" Makes the return of the bucket
        #     metadata conditional on whether the bucket's current metageneration does
        #     not match the given value.
        # @option options [String] "projection" Set of properties to return. Defaults to 'noAcl',
        #     also accepts 'full'.
        # @return [Google::Apis::StorageV1::Bucket]
        def get_bucket(bucket_name, options = {})
          raise ArgumentError.new("bucket_name is required") unless bucket_name

          @storage_json.get_bucket(bucket_name,
                                   :if_metageneration_match => options["ifMetagenerationMatch"],
                                   :if_metageneration_not_match => options["ifMetagenerationNotMatch"],
                                   :projection => options["projection"])
        end
      end

      class Mock
        def get_bucket(_bucket_name, _options = {})
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
