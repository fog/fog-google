module Fog
  module Storage
    class GoogleJSON
      class Real
        # List information about objects in an Google Storage bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to list object keys from
        # * options<~Hash> - config arguments for list.  Defaults to {}.
        #   * 'ifMetagenerationMatch'<~Long> - Makes the return of the bucket metadata
        #     conditional on whether the bucket's current metageneration matches the
        #     given value.
        #   * 'ifMetagenerationNotMatch'<~Long> - Makes the return of the bucket
        #     metadata conditional on whether the bucket's current metageneration does
        #     not match the given value.
        #   * 'projection'<~String> - Set of properties to return. Defaults to 'noAcl',
        #     also accepts 'full'.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     See Google documentation on Bucket resource:
        #     https://cloud.google.com/storage/docs/json_api/v1/buckets#resource
        #

        def get_bucket(bucket_name, options = {})
          raise ArgumentError.new("bucket_name is required") unless bucket_name

          api_method = @storage_json.buckets.get
          parameters = {
            "bucket" => bucket_name
          }
          parameters.merge! options

          request(api_method, parameters)
        end
      end

      class Mock
        def get_bucket(bucket_name, options = {})
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          response = Excon::Response.new
          name = /(\w+\.?)*/.match(bucket_name)
          if bucket_name == name.to_s
            if bucket = data[:buckets][bucket_name]
              contents = bucket[:objects].values.sort { |x, y| x["Key"] <=> y["Key"] }.reject do |object|
                (options["prefix"] && object["Key"][0...options["prefix"].length] != options["prefix"]) ||
                (options["marker"] && object["Key"] <= options["marker"])
              end.map do |object|
                data = object.reject { |key, _value| !%w(ETag Key).include?(key) }
                data.merge!("LastModified" => Time.parse(object["Last-Modified"]),
                            "Owner"        => bucket["Owner"],
                            "Size"         => object["Content-Length"].to_i)
                data
              end
              max_keys = options["max-keys"] || 1000
              size = [max_keys, 1000].min
              truncated_contents = contents[0...size]

              response.status = 200
              response.body = {
                "CommonPrefixes"  => [],
                "Contents"        => truncated_contents,
                "Marker"          => options["marker"],
                "Name"            => bucket["Name"],
                "Prefix"          => options["prefix"]
              }
              if options["max-keys"] && options["max-keys"] < response.body["Contents"].length
                response.body["Contents"] = response.body["Contents"][0...options["max-keys"]]
              end
            else
              response.status = 404
              raise(Excon::Errors.status_error({ :expects => 200 }, response))
            end
          else
            response.status = 400
            raise(Excon::Errors.status_error({ :expects => 200 }, response))
          end
          response
        end
      end
    end
  end
end
