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
        def put_bucket_acl(bucket_name, acl)
          raise ArgumentError.new("bucket_name is required") unless bucket_name
          raise ArgumentError.new("acl is required") unless acl

          api_method = @storage_json.bucket_access_controls.insert
          parameters = {
            "bucket" => bucket_name
          }
          body_object = acl

          request(api_method, parameters, body_object = body_object)
          #           data = <<-DATA
          # <AccessControlList>
          #   <Owner>
          #     #{tag('ID', acl['Owner']['ID'])}
          #   </Owner>
          #   <Entries>
          #     #{entries_list(acl['AccessControlList'])}
          #   </Entries>
          # </AccessControlList>
          # DATA

          #           request(:body     => data,
          #                   :expects  => 200,
          #                   :headers  => {},
          #                   :host     => "#{bucket_name}.#{@host}",
          #                   :method   => "PUT",
          #                   :query    => { "acl" => nil })
        end

        private

        def tag(name, value)
          # "<#{name}>#{value}</#{name}>"
        end

        def scope_tag(scope)
          # if %w(AllUsers AllAuthenticatedUsers).include?(scope["type"])
          #   "<Scope type='#{scope['type']}'/>"
          # else
          #   "<Scope type='#{scope['type']}'>" +
          #     scope.to_a.select { |pair| pair[0] != "type" }.map { |pair| tag(pair[0], pair[1]) }.join("\n") +
          #     "</Scope>"
          # end
        end

        def entries_list(access_control_list)
          # access_control_list.map do |entry|
          #   tag("Entry", scope_tag(entry["Scope"]) + tag("Permission", entry["Permission"]))
          # end.join("\n")
        end
      end
    end
  end
end
