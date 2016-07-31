module Fog
  module Storage
    class GoogleJSON
      class Real
        # Create a Google Storage bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to create
        # * options<~Hash> - config arguments for bucket.  Defaults to {}.
        #   * 'LocationConstraint'<~Symbol> - sets the location for the bucket
        #   * 'predefinedAcl'<~String> - Apply a predefined set of access controls to this bucket.
        #   * 'predefinedDefaultObjectAcl'<~String> - Apply a predefined set of default object access controls to this bucket.
        # * body_options<~Hash> - body arguments for bucket creation.
        #   See https://cloud.google.com/storage/docs/json_api/v1/buckets/insert#request-body
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 200
        #
        # ==== See also
        # https://cloud.google.com/storage/docs/json_api/v1/buckets/insert
        def put_bucket(bucket_name, options = {}, body_options = {})
          location = options["LocationConstraint"] if options["LocationConstraint"]

          api_method = @storage_json.buckets.insert
          parameters = {
            "project" => @project,
            "projection" => "full"
          }
          parameters.merge! options
          body_object = {
            "name" => bucket_name,
            "location" => location
          }
          body_object.merge! body_options

          request(api_method, parameters, body_object = body_object)
        end
      end

      class Mock
        def put_bucket(bucket_name, options = {}, _body_options = {})
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
