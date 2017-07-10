module Fog
  module Storage
    class GoogleJSON
      class Real
        # Fetch headers for an object in Google Storage
        # https://cloud.google.com/storage/docs/json_api/v1/objects/get
        #
        # @param bucket_name [String] Name of bucket to read from
        # @param object_name [String] Name of object to read
        # @param options [Hash] Optional hash of options
        # @option options [String] "If-Match" Returns object only if its etag matches this value; otherwise, raises Google::Apis::ClientError
        # @option options [DateTime] "If-Modified-Since" Returns object only if it has been modified since this time
        # @option options [String] "If-None-Match" Returns object only if its etag differs from this value
        # @option options [String] "If-Unmodified-Since" AReturns object only if it has not been modified since this time
        # @option options [String] "Range" Applies a predefined set of default object access controls
        # @option options [String] "versionId" Applies a predefined set of default object access controls
        # @return [Google::Apis::StorageV1::Object]
        def head_object(bucket_name, object_name, options = {})
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          raise ArgumentError.new("object_name is required") unless object_name

          request_options = ::Google::Apis::RequestOptions.default.merge(options)
          @storage_json.get_object(bucket_name, object_name,
                                   :options => request_options)
        end
      end

      class Mock
        def head_object(bucket_name, object_name, options = {})
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
