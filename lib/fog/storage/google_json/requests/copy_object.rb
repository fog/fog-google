module Fog
  module Storage
    class GoogleJSON
      class Real
        # Copy an object from one Google Storage bucket to another
        # https://cloud.google.com/storage/docs/json_api/v1/objects/copy
        #
        # ==== Parameters
        # * source_bucket_name<~String> - Name of source bucket
        # * source_object_name<~String> - Name of source object
        # * target_bucket_name<~String> - Name of bucket to create copy in
        # * target_object_name<~String> - Name for new copy of object
        # * options<~Hash>:
        #   * 'x-goog-metadata-directive'<~String> - Specifies whether to copy metadata from source or replace with data in request.  Must be in ['COPY', 'REPLACE']
        #   * 'x-goog-copy_source-if-match'<~String> - Copies object if its etag matches this value
        #   * 'x-goog-copy_source-if-modified_since'<~Time> - Copies object it it has been modified since this time
        #   * 'x-goog-copy_source-if-none-match'<~String> - Copies object if its etag does not match this value
        #   * 'x-goog-copy_source-if-unmodified-since'<~Time> - Copies object it it has not been modified since this time
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ETag'<~String> - etag of new object
        #     * 'LastModified'<~Time> - date object was last modified
        #
        def copy_object(source_bucket_name, source_object_name, target_bucket_name, target_object_name, options = {})
          api_method = @storage_json.objects.copy
          parameters = {
            "sourceBucket" => source_bucket_name,
            "sourceObject" => source_object_name,
            "destinationBucket" => target_bucket_name,
            "destinationObject" => target_object_name
          }
          parameters.merge! options

          request(api_method, parameters)
        end
      end

      class Mock
        def copy_object(source_bucket_name, source_object_name, target_bucket_name, target_object_name, _options = {})
          response = Excon::Response.new
          source_bucket = data[:buckets][source_bucket_name]
          source_object = source_bucket && source_bucket[:objects][source_object_name]
          target_bucket = data[:buckets][target_bucket_name]

          if source_object && target_bucket
            response.status = 200
            target_object = source_object.dup
            target_object["Name"] = target_object_name
            target_bucket[:objects][target_object_name] = target_object
            response.body = {
              "ETag"          => target_object["ETag"],
              "LastModified"  => Time.parse(target_object["Last-Modified"])
            }
          else
            response.status = 404
            raise(Excon::Errors.status_error({ :expects => 200 }, response))
          end

          response
        end
      end
    end
  end
end
