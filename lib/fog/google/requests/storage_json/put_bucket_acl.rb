module Fog
  module Storage
    class GoogleJSON
      class Mock
        def put_bucket_acl(_bucket_name, _acl)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # Change access control list for an Google Storage bucket
        # https://cloud.google.com/storage/docs/json_api/v1/bucketAccessControls/insert
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to create
        # * acl<~Hash> - ACL hash to add to bucket, see GCS documentation above
        #    * entity
        #    * role
        def put_bucket_acl(bucket_name, acl)
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          raise ArgumentError.new("acl is required") unless acl

          api_method = @storage_json.bucket_access_controls.insert
          parameters = {
            "bucket" => bucket_name
          }
          body_object = acl

          request(api_method, parameters, body_object = body_object)
        end
      end
    end
  end
end
