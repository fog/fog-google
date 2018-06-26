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
          options[:google_api_scope_url] = GOOGLE_STORAGE_JSON_API_SCOPE_URLS.join(" ")
          @host = options[:host] || "storage.googleapis.com"

          @client = initialize_google_client(options)
          @storage_json = ::Google::Apis::StorageV1::StorageService.new
          @storage_json.client_options.open_timeout_sec = options[:open_timeout_sec] if options[:open_timeout_sec]
          @storage_json.client_options.read_timeout_sec = options[:read_timeout_sec] if options[:read_timeout_sec]
          @storage_json.client_options.send_timeout_sec = options[:send_timeout_sec] if options[:send_timeout_sec]
        end

        def signature(params)
          string_to_sign = <<-DATA
#{params[:method]}
#{params[:headers]['Content-MD5']}
#{params[:headers]['Content-Type']}
#{params[:headers]['Date']}
DATA

          google_headers = {}
          canonical_google_headers = ""
          params[:headers].each do |key, value|
            google_headers[key] = value if key[0..6] == "x-goog-"
          end

          google_headers = google_headers.sort_by { |a| a[0] }
          google_headers.each do |key, value|
            canonical_google_headers << "#{key}:#{value}\n"
          end
          string_to_sign << canonical_google_headers.to_s

          canonical_resource = "/"
          if subdomain = params.delete(:subdomain)
            canonical_resource << "#{CGI.escape(subdomain).downcase}/"
          end
          canonical_resource << params[:path].to_s
          canonical_resource << "?"
          (params[:query] || {}).each_key do |key|
            if %w(acl cors location logging requestPayment versions versioning).include?(key)
              canonical_resource << "#{key}&"
            end
          end
          canonical_resource.chop!
          string_to_sign << canonical_resource.to_s

          key = OpenSSL::PKey::RSA.new(@client.signing_key)
          digest = OpenSSL::Digest::SHA256.new
          signed_string = key.sign(digest, string_to_sign)

          Base64.encode64(signed_string).chomp!
        end
      end
    end
  end
end
