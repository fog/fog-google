module Fog
  module Storage
    class GoogleJSON
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
