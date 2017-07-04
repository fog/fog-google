module Fog
  module Storage
    class GoogleJSON
      class Real
        # Create an object in an Google Storage bucket
        # https://cloud.google.com/storage/docs/json_api/v1/objects/insert
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket to create object in
        # * object_name<~String> - Name of object to create
        # * data<~File> - File or String to create object from
        # * options<~Hash>:
        #   * 'Cache-Control'<~String> - Caching behaviour
        #   * 'Content-Disposition'<~String> - Presentational information for the object
        #   * 'Content-Encoding'<~String> - Encoding of object data
        #   * 'Content-Length'<~String> - Size of object in bytes (defaults to object.read.length)
        #   * 'Content-MD5'<~String> - Base64 encoded 128-bit MD5 digest of message (defaults to Base64 encoded MD5 of object.read)
        #   * 'Content-Type'<~String> - Standard MIME type describing contents (defaults to MIME::Types.of.first)
        #   * 'x-goog-acl'<~String> - Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        #   * "x-goog-meta-#{name}" - Headers to be returned with object, note total size of request without body must be less than 8 KB.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'ETag'<~String> - etag of new object
        def put_object(bucket_name, object_name, data, options = {})
          if options["contentType"]
            mime_type = options["contentType"]
            if data.is_a? String
              data = StringIO.new(data)
            end
          elsif data.is_a? String
            data = StringIO.new(data)
            mime_type = "text/plain"
          elsif data.is_a? ::File
            mime_type = Fog::Storage.parse_data(data)[:headers]["Content-Type"]
          end

          media = ::Google::APIClient::UploadIO.new(data, mime_type, object_name)
          api_method = @storage_json.objects.insert
          parameters = {
            "uploadType" => "multipart",
            "bucket" => bucket_name,
            "name" => object_name
          }

          body_object = {
            :contentType => mime_type,
            :contentEncoding => options["contentEncoding"]
          }
          body_object.merge! options

          acl = []
          case options["predefinedAcl"]
          when "publicRead"
            acl.push("entity" => "allUsers", "role" => "READER")
          when "publicReadWrite"
            acl.push("entity" => "allUsers", "role" => "OWNER")
          when "authenticatedRead"
            acl.push("entity" => "allAuthenticatedUsers", "role" => "READER")
          end

          unless acl.empty?
            body_object[:acl] = acl
          end

          request(api_method, parameters, body_object = body_object, media = media)
        end
      end

      class Mock
        def put_object(bucket_name, object_name, data, options = {})
          acl = options["x-goog-acl"] || "private"
          if !%w(private publicRead publicReadWrite authenticatedRead).include?(acl)
            raise Excon::Errors::BadRequest.new("invalid x-goog-acl")
          else
            self.data[:acls][:object][bucket_name] ||= {}
            self.data[:acls][:object][bucket_name][object_name] = self.class.acls(acl)
          end

          data = Fog::Storage.parse_data(data)
          data[:body] = data[:body].read unless data[:body].is_a?(String)
          response = Excon::Response.new
          if (bucket = self.data[:buckets][bucket_name])
            response.status = 200
            object = {
              :body             => data[:body],
              "Content-Type"    => options["Content-Type"] || data[:headers]["Content-Type"],
              "ETag"            => Fog::Google::Mock.etag,
              "Key"             => object_name,
              "Last-Modified"   => Fog::Time.now.to_date_header,
              "Content-Length"  => options["Content-Length"] || data[:headers]["Content-Length"]
            }

            for key, value in options
              case key
              when "Cache-Control", "Content-Disposition", "Content-Encoding", "Content-MD5", "Expires", /^x-goog-meta-/
                object[key] = value
              end
            end

            bucket[:objects][object_name] = object
            response.headers = {
              "Content-Length"  => object["Content-Length"],
              "Content-Type"    => object["Content-Type"],
              "ETag"            => object["ETag"],
              "Last-Modified"   => object["Last-Modified"]
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
