module Fog
  module Google
    class SQL
      class Real
        include Fog::Google::Shared

        attr_accessor :client
        attr_reader :sql

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_SQL_API_VERSION, GOOGLE_SQL_BASE_URL)
          options[:google_api_scope_url] = GOOGLE_SQL_API_SCOPE_URLS.join(" ")

          @client = initialize_google_client(options)
          @sql = @client.discovered_api("sqladmin", api_version)
        end
      end
    end
  end
end
