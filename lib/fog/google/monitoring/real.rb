module Fog
  module Google
    class Monitoring
      class Real
        include Fog::Google::Shared

        attr_accessor :client
        attr_reader :monitoring

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_MONITORING_API_VERSION, GOOGLE_MONITORING_BASE_URL)
          options.merge!(:google_api_scope_url => GOOGLE_MONITORING_API_SCOPE_URLS.join(" "))

          @client = initialize_google_client(options)
          @monitoring = @client.discovered_api("cloudmonitoring", api_version)
        end
      end
    end
  end
end
