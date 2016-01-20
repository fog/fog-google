module Fog
  module Storage
    class GoogleJSON
      class Real
        # Create an Google Storage bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to create
        # * options<~Hash> - config arguments for bucket.  Defaults to {}.
        #   * 'LocationConstraint'<~Symbol> - sets the location for the bucket
        #   * 'x-amz-acl'<~String> - Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 200
        def put_bucket(bucket_name, options = {})
          location = options["LocationConstraint"] if options["LocationConstraint"]

          api_method = @storage_json.buckets.insert
          parameters = {
            "project" => @project,
            "projection" => "full"
          }
          body_object = {
            "name" => bucket_name,
            "location" => location
          }
          parameters.merge! options

          request(api_method, parameters, body_object = body_object)
        end
      end

      class Mock
        def put_bucket(bucket_name, options = {})
          acl = options["x-goog-acl"] || "private"
          if !%w(private publicRead publicReadWrite authenticatedRead).include?(acl)
            raise Excon::Errors::BadRequest.new("invalid x-goog-acl")
          else
            data[:acls][:bucket][bucket_name] = self.class.acls(options[acl])
          end
          response = Excon::Response.new
          response.status = 200
          bucket = {
            :objects        => {},
            "Name"          => bucket_name,
            "CreationDate"  => Time.now,
            "Owner"         => { "DisplayName" => "owner", "ID" => "some_id" },
            "Payer"         => "BucketOwner"
          }
          if options["LocationConstraint"]
            bucket["LocationConstraint"] = options["LocationConstraint"]
          else
            bucket["LocationConstraint"] = ""
          end
          if data[:buckets][bucket_name].nil?
            data[:buckets][bucket_name] = bucket
          else
            response.status = 409
            raise(Excon::Errors.status_error({ :expects => 200 }, response))
          end
          response
        end
      end
    end
  end
end
