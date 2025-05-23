module Fog
  module Google
    class StorageXML
      class Real
        # Get access control list for an Google Storage object
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket containing object
        # * object_name<~String> - name of object to get access control list for
        # * options<~Hash>:
        #   * 'versionId'<~String> - specify a particular version to retrieve
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'AccessControlPolicy'<~Hash>
        #       * 'Owner'<~Hash>:
        #         * 'DisplayName'<~String> - Display name of object owner
        #         * 'ID'<~String> - Id of object owner
        #       * 'AccessControlList'<~Array>:
        #         * 'Grant'<~Hash>:
        #           * 'Grantee'<~Hash>:
        #              * 'DisplayName'<~String> - Display name of grantee
        #              * 'ID'<~String> - Id of grantee
        #             or
        #              * 'URI'<~String> - URI of group to grant access for
        #           * 'Permission'<~String> - Permission, in [FULL_CONTROL, WRITE, WRITE_ACP, READ, READ_ACP]
        #
        def get_object_acl(bucket_name, object_name, options = {})
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          raise ArgumentError.new("object_name is required") unless object_name
          query = { "acl" => nil }
          if version_id = options.delete("versionId")
            query["versionId"] = version_id
          end
          request(:expects    => 200,
                  :headers    => {},
                  :host       => "#{bucket_name}.#{@host}",
                  :idempotent => true,
                  :method     => "GET",
                  :parser     => Fog::Google::Parsers::Storage::AccessControlList.new,
                  :path       => Fog::Google.escape(object_name),
                  :query      => query)
        end
      end

      class Mock
        def get_object_acl(bucket_name, object_name)
          response = Excon::Response.new
          if acl = data[:acls][:object][bucket_name] && data[:acls][:object][bucket_name][object_name]
            response.status = 200
            response.body = acl
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
