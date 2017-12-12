module Fog
  module DNS
    class Google
      class Real
        include Fog::Google::Shared

        attr_reader :dns

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_DNS_API_VERSION, GOOGLE_DNS_BASE_URL)
          options[:google_api_scope_url] = GOOGLE_DNS_API_SCOPE_URLS.join(" ")
          initialize_google_client(options)
          @dns = ::Google::Apis::DnsV1::DnsService.new
        end
      end
    end
  end
end
