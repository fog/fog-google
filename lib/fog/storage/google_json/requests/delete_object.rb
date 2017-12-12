module Fog
  module Storage
    class GoogleJSON
      class Real
        # Delete an object from Google Storage
        # https://cloud.google.com/storage/docs/json_api/v1/objects/delete
        #
        # @param bucket_name [String] Name of bucket containing object to delete
        # @param object_name [String] Name of object to delete
        def delete_object(bucket_name, object_name)
          @storage_json.delete_object(bucket_name, object_name)
        end
      end

      class Mock
        def delete_object(_bucket_name, _object_name)
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
