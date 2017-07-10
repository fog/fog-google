module Fog
  module Storage
    class GoogleJSON
      class Real
        # Copy an object from one Google Storage bucket to another
        # https://cloud.google.com/storage/docs/json_api/v1/objects/copy
        #
        # @param source_bucket_name [String] Name of source bucket
        # @param source_object_name [String] Name of source object
        # @param target_bucket_name [String] Name of bucket to create copy in
        # @param target_object_name [String] Name of new copy of object
        # @param options [Hash] Optional hash of options
        # @option options [String] "x-goog-metadata-directive" Specifies whether to copy metadata from source or replace with data in request.  Must be in ['COPY', 'REPLACE']
        # @option options [String] "x-goog-copy_source-if-match" Copies object if its etag matches this value
        # @option options [DateTime] "x-goog-copy_source-if-modified_since" Copies object it it has been modified since this time
        # @option options [String] "x-goog-copy_source-if-none-match" Copies object if its etag does not match this value
        # @option options [DateTime] "x-goog-copy_source-if-unmodified-since"" Copies object it it has not been modified since this time
        # @return [Google::Apis::StorageV1::Object] copy of object
        def copy_object(source_bucket_name, source_object_name, target_bucket_name, target_object_name, options = {})
          request_options = ::Google::Apis::RequestOptions.default.merge(options)
          @storage_json.copy_object(source_bucket_name, source_object_name,
                                    target_bucket_name, target_object_name, request_options)
        end
      end

      class Mock
        def copy_object(source_bucket_name, source_object_name, target_bucket_name, target_object_name, _options = {})
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
