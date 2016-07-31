module Fog
  module Storage
    class GoogleJSON
      class Real
        # Retrieves a list of buckets for a given project.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash> - Hash of bucket items
        #     * 'kind'<~String> - The kind of item this is (storage#buckets)
        #     * 'items'<~Array> - The array of items.
        #
        # ==== See Also
        # https://cloud.google.com/storage/docs/json_api/v1/buckets/list
        # TODO: check if very large lists require working with nextPageToken
        def list_buckets
          api_method = @storage_json.buckets.list
          parameters = {
            "project" => @project
          }

          request(api_method, parameters)
        end
      end
      class Mock
        def list_buckets
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
