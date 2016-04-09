module Fog
  module Storage
    class GoogleJSON < Fog::Service
      autoload :Mock, File.expand_path("../google_json/mock", __FILE__)
      autoload :Real, File.expand_path("../google_json/real", __FILE__)
      autoload :Utils, File.expand_path("../google_json/utils", __FILE__)

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
      model_path "fog/storage/google_json/models"
      collection :directories
      model :directory
      collection :files
      model :file

      ##
      # Requests
      request_path "fog/storage/google_json/requests"
      request :copy_object
      request :delete_bucket
      request :delete_object
      request :get_bucket
      request :get_bucket_acl
      request :get_object
      request :get_object_acl
      # request :get_object_torrent
      request :get_object_http_url
      request :get_object_https_url
      request :get_object_url
      # request :get_service
      request :head_object
      request :put_bucket
      request :put_bucket_acl
      request :put_object
      request :put_object_acl
      request :put_object_url
    end
  end
end
