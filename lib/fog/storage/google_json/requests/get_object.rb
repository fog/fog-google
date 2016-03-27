module Fog
  module Storage
    class GoogleJSON
      class Real
        # Get an object from Google Storage
        # https://cloud.google.com/storage/docs/json_api/v1/objects/get
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket to read from
        # * object_name<~String> - Name of object to read
        # * options<~Hash>:
        #   * 'If-Match'<~String> - Returns object only if its etag matches this value, otherwise returns 412 (Precondition Failed).
        #   * 'If-Modified-Since'<~Time> - Returns object only if it has been modified since this time, otherwise returns 304 (Not Modified).
        #   * 'If-None-Match'<~String> - Returns object only if its etag differs from this value, otherwise returns 304 (Not Modified)
        #   * 'If-Unmodified-Since'<~Time> - Returns object only if it has not been modified since this time, otherwise returns 412 (Precodition Failed).
        #   * 'Range'<~String> - Range of object to download
        #   * 'versionId'<~String> - specify a particular version to retrieve
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - Contents of object
        #   * headers<~Hash>:
        #     * 'Content-Length'<~String> - Size of object contents
        #     * 'Content-Type'<~String> - MIME type of object
        #     * 'ETag'<~String> - Etag of object
        #     * 'Last-Modified'<~String> - Last modified timestamp for object
        #
        def get_object(bucket_name, object_name, _options = {}, &_block)
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          raise ArgumentError.new("object_name is required") unless object_name

          api_method = @storage_json.objects.get
          parameters = {
            "bucket" => bucket_name,
            "object" => object_name,
            "projection" => "full"
          }

          object = request(api_method, parameters)

          # Get the body of the object (can't use request for this)
          parameters["alt"] = "media"
          client_parms = {
            :api_method => api_method,
            :parameters => parameters
          }

          result = @client.execute(client_parms)
          object.headers = object.body
          object.body = result.body.nil? || result.body.empty? ? nil : result.body
          object
        end
      end

      class Mock
        def get_object(bucket_name, object_name, options = {}, &block)
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          raise ArgumentError.new("object_name is required") unless object_name
          response = Excon::Response.new
          if (bucket = data[:buckets][bucket_name]) && (object = bucket[:objects][object_name])
            if options["If-Match"] && options["If-Match"] != object["ETag"]
              response.status = 412
            elsif options["If-Modified-Since"] && options["If-Modified-Since"] >= Time.parse(object["Last-Modified"])
              response.status = 304
            elsif options["If-None-Match"] && options["If-None-Match"] == object["ETag"]
              response.status = 304
            elsif options["If-Unmodified-Since"] && options["If-Unmodified-Since"] < Time.parse(object["Last-Modified"])
              response.status = 412
            else
              response.status = 200
              for key, value in object
                case key
                when "Cache-Control", "Content-Disposition", "Content-Encoding", "Content-Length", "Content-MD5", "Content-Type", "ETag", "Expires", "Last-Modified", /^x-goog-meta-/
                  response.headers[key] = value
                end
              end
              unless block_given?
                response.body = object[:body]
              else
                data = StringIO.new(object[:body])
                remaining = data.length
                while remaining > 0
                  chunk = data.read([remaining, Excon::CHUNK_SIZE].min)
                  block.call(chunk)
                  remaining -= Excon::CHUNK_SIZE
                end
              end
            end
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
