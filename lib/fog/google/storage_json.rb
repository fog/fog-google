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

      module Utils
        def http_url(params, expires)
          "http://" << host_path_query(params, expires)
        end

        def https_url(params, expires)
          "https://" << host_path_query(params, expires)
        end

        def url(params, expires)
          Fog::Logger.deprecation("Fog::Storage::Google => #url is deprecated, use #https_url instead [light_black](#{caller.first})[/]")
          https_url(params, expires)
        end

        private

        def host_path_query(params, expires)
          params[:headers]["Date"] = expires.to_i
          params[:path] = CGI.escape(params[:path]).gsub("%2F", "/")
          query = [params[:query]].compact
          query << "GoogleAccessId=#{@client.authorization.issuer}"
          query << "Signature=#{CGI.escape(signature(params))}"
          query << "Expires=#{params[:headers]['Date']}"
          "#{params[:host]}/#{params[:path]}?#{query.join('&')}"
        end
      end

      class Mock
        include Utils
        include Fog::Google::Shared

        def initialize(options = {})
          shared_initialize(options[:google_project], GOOGLE_STORAGE_JSON_API_VERSION, GOOGLE_STORAGE_JSON_BASE_URL)
        end

        def signature(_params)
          "foo"
        end
      end

      class Real
        include Utils
        include Fog::Google::Shared

        attr_accessor :client
        attr_reader :storage_json

        def initialize(options = {})
          shared_initialize(options[:google_project], GOOGLE_STORAGE_JSON_API_VERSION, GOOGLE_STORAGE_JSON_BASE_URL)
          options.merge!(:google_api_scope_url => GOOGLE_STORAGE_JSON_API_SCOPE_URLS.join(" "))
          @host = options[:host] || "storage.googleapis.com"

          @client = initialize_google_client(options)
          @storage_json = @client.discovered_api("storage", api_version)
        end

        def signature(params)
          string_to_sign =
<<-DATA
#{params[:method]}
#{params[:headers]['Content-MD5']}
#{params[:headers]['Content-Type']}
#{params[:headers]['Date']}
DATA

          google_headers = {}
          canonical_google_headers = ""
          for key, value in params[:headers]
            google_headers[key] = value if key[0..6] == "x-goog-"
          end

          google_headers = google_headers.sort { |x, y| x[0] <=> y[0] }
          for key, value in google_headers
            canonical_google_headers << "#{key}:#{value}\n"
          end
          string_to_sign << "#{canonical_google_headers}"

          canonical_resource = "/"
          if subdomain = params.delete(:subdomain)
            canonical_resource << "#{CGI.escape(subdomain).downcase}/"
          end
          canonical_resource << "#{params[:path]}"
          canonical_resource << "?"
          for key in (params[:query] || {}).keys
            if %w(acl cors location logging requestPayment torrent versions versioning).include?(key)
              canonical_resource << "#{key}&"
            end
          end
          canonical_resource.chop!
          string_to_sign << "#{canonical_resource}"

          key = OpenSSL::PKey::RSA.new(@client.authorization.signing_key)
          digest = OpenSSL::Digest::SHA256.new
          signed_string = key.sign(digest, string_to_sign)

          Base64.encode64(signed_string).chomp!
        end
      end
    end
  end
end
