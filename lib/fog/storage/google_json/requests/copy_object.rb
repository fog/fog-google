module Fog
  module Storage
    class GoogleJSON
      class Real
        # Copy an object from one Google Storage bucket to another
        #
        # @param source_bucket [String] Name of source bucket
        # @param source_object [String] Name of source object
        # @param target_bucket [String] Name of bucket to create copy in
        # @param target_object [String] Name of new copy of object
        #
        # @see https://cloud.google.com/storage/docs/json_api/v1/objects/copy
        # @return [Google::Apis::StorageV1::Object] copy of object
        def copy_object(source_bucket, source_object,
                        target_bucket, target_object, options = {})
          request_options = ::Google::Apis::RequestOptions.default.merge(options)
          @storage_json.copy_object(source_bucket, source_object,
                                    target_bucket, target_object,
                                    request_options)
        end
      end

      class Mock
        def copy_object(_source_bucket, _source_object,
                        _target_bucket, _target_object, _options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
