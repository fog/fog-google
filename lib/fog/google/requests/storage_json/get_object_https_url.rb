module Fog
  module Google
    class StorageJSON
      module GetObjectHttpsUrl
        # Formerly included "expires", but no doesn't seem to exist anymore?
        def get_object_https_url(bucket_name, object_name)
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          raise ArgumentError.new("object_name is required") unless object_name

          api_method = @storage_json.objects.get
          parameters = {
            "bucket" => bucket_name,
            "object" => object_name
          }

          response = request(api_method, parameters)
          response.body["mediaLink"]
          # https_url({
          #             :headers  => {},
          #             :host     => @host,
          #             :method   => "GET",
          #             :path     => "#{bucket_name}/#{object_name}"
          #           }, expires)
        end
      end

      class Real
        # Get an expiring object https url from Google Storage
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket containing object
        # * object_name<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/dev/S3_QSAuth.html

        include GetObjectHttpsUrl
      end

      class Mock # :nodoc:all
        include GetObjectHttpsUrl
      end
    end
  end
end
