module Fog
  module Storage
    class GoogleJSON
      class Real
        # Retrieves a list of buckets for a given project
        # https://cloud.google.com/storage/docs/json_api/v1/buckets/list
        #
        # @return [Google::Apis::StorageV1::Buckets]
        # TODO: check if very large lists require working with nextPageToken
        def list_buckets
          @storage_json.list_buckets(@project)
        end
      end
      class Mock
        def list_buckets
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
