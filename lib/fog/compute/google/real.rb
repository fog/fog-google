module Fog
  module Compute
    class Google
      class Real
        include Fog::Google::Shared

        attr_accessor :client
        attr_reader :compute, :extra_global_projects

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_COMPUTE_API_VERSION, GOOGLE_COMPUTE_BASE_URL)
          options.merge!(:google_api_scope_url => GOOGLE_COMPUTE_API_SCOPE_URLS.join(" "))

          @client = initialize_google_client(options)
          @compute = @client.discovered_api("compute", api_version)
          @resourceviews = @client.discovered_api("resourceviews", "v1beta1")
          @extra_global_projects = options[:google_extra_global_projects] || []
        end
      end
    end
  end
end
