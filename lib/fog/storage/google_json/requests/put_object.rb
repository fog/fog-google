module Fog
  module Storage
    class GoogleJSON
      class Real
        # Create an object in an Google Storage bucket
        # https://cloud.google.com/storage/docs/json_api/v1/objects/insert
        #
        # @param bucket_name [String] Name of bucket to create object in
        # @param object_name [String] Name of object to create
        # @param data [File|String] File or String to create object from
        # @option options [String] "predefinedAcl" Applies a predefined set of access controls to this bucket.
        # @option options [String] "Cache-Control" Caching behaviour
        # @option options [DateTime] "Content-Disposition" Presentational information for the object
        # @option options [String] "Content-Encoding" Encoding of object data
        # @option options [String] "Content-MD5" Base64 encoded 128-bit MD5 digest of message (defaults to Base64 encoded MD5 of object.read)
        # @option options [String] "Content-Type" Standard MIME type describing contents (defaults to MIME::Types.of.first)ols
        # @option options [String] "x-goog-acl" Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        # @option options [String] "x-goog-meta-#{name}" Headers to be returned with object, note total size of request without body must be less than 8 KB.
        # @return [Google::Apis::StorageV1::Object]
        def put_object(bucket_name, object_name, data, options = {})
          unless options["Content-Type"]
            if data.is_a? String
              data = StringIO.new(data)
              options["Content-Type"] = "text/plain"
            elsif data.is_a? ::File
              options["Content-Type"] = Fog::Storage.parse_data(data)[:headers]["Content-Type"]
            end
          end

          object_config = ::Google::Apis::StorageV1::Object.new(
            :name => object_name
          )
          request_options = ::Google::Apis::RequestOptions.default.merge(options)
          @storage_json.insert_object(bucket_name, object_config,
                                      :upload_source => data,
                                      :predefined_acl => options["predefinedAcl"],
                                      :options => request_options)
        end
      end

      class Mock
        def put_object(_bucket_name, _object_name, _data, _options = {})
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
