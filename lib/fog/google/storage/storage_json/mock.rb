module Fog
  module Google
    class StorageJSON
      class Mock
        include Utils
        include Fog::Google::Shared

        MockClient = Struct.new(:issuer)

        def initialize(options = {})
          @options = options.dup
          api_base_url = storage_api_base_url_for_universe(universe_domain)
          shared_initialize(options[:google_project], GOOGLE_STORAGE_JSON_API_VERSION, api_base_url)
          @client = MockClient.new('test')
          @storage_json = MockClient.new('test')
          @iam_service = MockClient.new('test')
        end

        def signature(_params)
          "foo"
        end

        def bucket_base_url
          storage_base_url_for_universe(universe_domain)
        end

        def google_access_id
          "my-account@project.iam.gserviceaccount"
        end

        private

        def universe_domain
          universe_domain_from_options(@options)
        end
      end
    end
  end
end
