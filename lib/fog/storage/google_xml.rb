module Fog
  module Storage
    class GoogleXML < Fog::Service
      autoload :Mock, File.expand_path("../google_xml/mock", __FILE__)
      autoload :Real, File.expand_path("../google_xml/real", __FILE__)
      autoload :Utils, File.expand_path("../google_xml/utils", __FILE__)

      requires :google_storage_access_key_id, :google_storage_secret_access_key
      recognizes :host, :port, :scheme, :persistent, :path_style

      model_path "fog/storage/google_xml/models"
      collection :directories
      model :directory
      collection :files
      model :file

      request_path "fog/storage/google_xml/requests"
      request :copy_object
      request :delete_bucket
      request :delete_object
      request :delete_object_url
      request :get_bucket
      request :get_bucket_acl
      request :get_object
      request :get_object_acl
      request :get_object_http_url
      request :get_object_https_url
      request :get_object_url
      request :get_service
      request :head_object
      request :put_bucket
      request :put_bucket_acl
      request :put_object
      request :put_object_acl
      request :put_object_url
    end
  end
end
