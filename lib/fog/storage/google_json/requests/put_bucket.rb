module Fog
  module Storage
    class GoogleJSON
      class Real
        # Create a Google Storage bucket
        #
        # @param bucket_name [String] Name of bucket to list
        # @param options [Hash] Optional hash of options
        # @option options [String] "LocationConstraint" sets the location for the bucket
        # @option options [String] "predefinedAcl" Applies a predefined set of access controls to this bucket.
        # @option options [String] "predefinedDefaultObjectAcl" Applies a predefined set of default object access controls
        # @return [Google::Apis::StorageV1::Bucket]
        def put_bucket(bucket_name, options = {})
          bucket = ::Google::Apis::StorageV1::Bucket.new(
            :name => bucket_name,
            :location => options["LocationConstraint"]
          )

          @storage_json.insert_bucket(@project, bucket,
                                      :predefined_acl => options["predefinedAcl"],
                                      :predefined_default_object_acl => options["predefined_default_object_acl"],
                                      :projection => "full")
        end
      end

      class Mock
        def put_bucket(_bucket_name, _options = {}, _body_options = {})
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
