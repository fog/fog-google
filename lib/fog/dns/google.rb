module Fog
  module DNS
    class Google < Fog::Service
      autoload :Mock, File.expand_path("../google/mock", __FILE__)
      autoload :Real, File.expand_path("../google/real", __FILE__)

      requires :google_project
      recognizes(
        :app_name,
        :app_version,
        :google_application_default,
        :google_auth,
        :google_client,
        :google_client_options,
        :google_key_location,
        :google_key_string,
        :google_json_key_location,
        :google_json_key_string
      )

      GOOGLE_DNS_API_VERSION     = "v1".freeze
      GOOGLE_DNS_BASE_URL        = "https://www.googleapis.com/dns/".freeze
      GOOGLE_DNS_API_SCOPE_URLS  = %w(https://www.googleapis.com/auth/ndev.clouddns.readwrite).freeze

      ##
      # MODELS
      model_path "fog/dns/google/models"

      # Zone
      model :zone
      collection :zones

      # Record
      model :record
      collection :records

      # Change
      model :change
      collection :changes

      # Project
      model :project
      collection :projects

      ##
      # REQUESTS
      request_path "fog/dns/google/requests"

      # Zone
      request :create_managed_zone
      request :delete_managed_zone
      request :get_managed_zone
      request :list_managed_zones

      # Record
      request :list_resource_record_sets

      # Change
      request :create_change
      request :get_change
      request :list_changes

      # Project
      request :get_project
    end
  end
end
