require "tempfile"

module Fog
  module Storage
    class GoogleJSON
      class Real
        # Get an object from Google Storage
        # https://cloud.google.com/storage/docs/json_api/v1/objects/get
        #
        # @param bucket_name [String] Name of bucket to create object in
        # @param object_name [String] Name of object to create
        # @param options [Hash] Optional hash of options
        # @option options [String] "If-Match" Returns object only if its etag matches this value; otherwise, raises Google::Apis::ClientError
        # @option options [DateTime] "If-Modified-Since" Returns object only if it has been modified since this time
        # @option options [String] "If-None-Match" Returns object only if its etag differs from this value
        # @option options [String] "If-Unmodified-Since" AReturns object only if it has not been modified since this time
        # @option options [String] "Range" Applies a predefined set of default object access controls
        # @option options [String] "versionId" Applies a predefined set of default object access controls
        # @return [Hash]
        #   * :name [String] - Name of object
        #   * :bucket [String] - Name of containing bucket
        #   * :body [String] - Content of the object
        #   * :content_type [String] - Content-Type of the object data.
        #   * :crc32c [String] - CRC32c checksum; encoded using base64
        #   * :etag [String] - HTTP 1.1 Entity tag for the objec
        #   * :generation [String] - Content generation of this object
        #   * :metageneration [String] - Metadata version of this generation
        #   * :id [String] - ID of the object
        #   * :kind [String] - Kind of item this is
        #   * :md5_hash [String] - MD5 hash of the data; encoded using base64
        #   * :media_link [String] - Media download link
        #   * :self_link [String] - Link to this object
        #   * :size [String] - Content-Length of data in bytes
        #   * :storage_class [String] - Storage Class of the object
        #   * :time_created [DateTime] - The creation time of the object
        #   * :updated [DateTime] - The modfication time of the object metadata
        def get_object(bucket_name, object_name, options = {})
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          raise ArgumentError.new("object_name is required") unless object_name

          # The previous semantics require returning the content of the request
          # rather than taking a filename to populate. Hence, tempfile.
          buf = Tempfile.new("fog-google-storage-temp")

          # Two requests are necessary, first for metadata, then for content.
          # google-api-ruby-client doesn't allow fetching both metadata and content
          request_options = ::Google::Apis::RequestOptions.default.merge(options)
          object = @storage_json.get_object(bucket_name, object_name,
                                            :options => request_options).to_h
          @storage_json.get_object(bucket_name, object_name,
                                   :download_dest => buf.path,
                                   :options => request_options)

          object[:body] = buf.read
          buf.unlink

          object.to_h
        end
      end

      class Mock
        def get_object(_bucket_name, _object_name, _options = {})
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
