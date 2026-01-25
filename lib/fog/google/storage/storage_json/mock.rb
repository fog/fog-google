module Fog
  module Google
    class StorageJSON
      class Mock
        include Utils
        include Fog::Google::Shared

        MockClient = Struct.new(:issuer)

        def initialize(options = {})
          shared_initialize(options[:google_project], GOOGLE_STORAGE_JSON_API_VERSION, GOOGLE_STORAGE_JSON_BASE_URL)
          @options = options.dup
          @client = MockClient.new('test')
          @storage_json = MockClient.new('test')
          @iam_service = MockClient.new('test')
        end

        def signature(_params)
          "foo"
        end

        def bucket_base_url
          if @options[:google_json_root_url]
            @options[:google_json_root_url]
          else
            GOOGLE_STORAGE_BUCKET_BASE_URL
          end
        end

        def google_access_id
          "my-account@project.iam.gserviceaccount"
        end
      end
    end
  end
end
