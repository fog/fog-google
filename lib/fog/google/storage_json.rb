module Fog
  module Storage
    class GoogleJSON < Fog::Service
      requires :google_project
      recognizes :google_client_email, :google_key_location, :google_key_string, :google_client,
                 :app_name, :app_version, :google_json_key_location, :google_json_key_string

      # https://cloud.google.com/storage/docs/json_api/v1/
      GOOGLE_STORAGE_JSON_API_VERSION = "v1"
      GOOGLE_STORAGE_JSON_BASE_URL = "https://www.googleapis.com/storage/"

      # TODO: Come up with a way to only request a subset of permissions.
      # https://cloud.google.com/storage/docs/json_api/v1/how-tos/authorizing
      GOOGLE_STORAGE_JSON_API_SCOPE_URLS = %w(https://www.googleapis.com/auth/devstorage.full_control)

      ##
      # Models
      model_path "fog/google/models/storage_json"
      collection :directories
      model :directory
      collection :files
      model :file

      ##
      # Requests
      request_path "fog/google/requests/storage_json"
      request :copy_object
      request :delete_bucket
      request :delete_object
      request :get_bucket
      request :get_bucket_acl
      request :get_object
      request :get_object_acl
      # request :get_object_torrent
      # request :get_object_http_url
      request :get_object_https_url
      request :get_object_url
      # request :get_service
      request :head_object
      request :put_bucket
      request :put_bucket_acl
      request :put_object
      request :put_object_acl
      request :put_object_url

      class Mock
        include Fog::Google::Shared

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_STORAGE_JSON_API_VERSION, GOOGLE_STORAGE_JSON_BASE_URL)
        end
      end

      class Real
        include Fog::Google::Shared

        attr_accessor :client
        attr_reader :storage_json

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_STORAGE_JSON_API_VERSION, GOOGLE_STORAGE_JSON_BASE_URL)
          options.merge!(:google_api_scope_url => GOOGLE_STORAGE_JSON_API_SCOPE_URLS.join(" "))

          @client = initialize_google_client(options)
          @storage_json = @client.discovered_api("storage", api_version)
        end
      end
    end
  end
end
