module Fog
  module Google
    module Shared
      attr_reader :project, :api_version, :api_url

      ##
      # Initializes shared attributes
      #
      # @param [String] project Google Cloud Project
      # @param [String] api_version Google API version
      # @param [String] base_url Google API base url
      # @return [void]
      def shared_initialize(project, api_version, base_url)
        @project = project
        @api_version = api_version
        @api_url = base_url + api_version + "/projects/"
      end

      ##
      # Initializes the Google API Client
      #
      # @param [Hash] options Google API options
      # @option options [Google::Auth|Signet] :google_auth Manually created authorization to use
      # @option options [String] :google_client_email A @developer.gserviceaccount.com email address to use
      # @option options [String] :google_key_location The location of a pkcs12 key file
      # @option options [String] :google_key_string The content of the pkcs12 key file
      # @option options [String] :google_json_key_location The location of a JSON key file
      # @option options [String] :google_json_key_string The content of the JSON key file
      # @option options [String] :google_api_scope_url The access scope URLs
      # @option options [String] :app_name The app name to set in the user agent
      # @option options [String] :app_version The app version to set in the user agent
      # @option options [Google::APIClient] :google_client Existing Google API Client
      # @option options [Hash] :google_client_options A hash to send adition options to Google API Client
      # @return [Google::APIClient] Google API Client
      # @raises [ArgumentError] If there is any missing argument
      def initialize_google_client(options)
        # NOTE: loaded here to avoid requiring this as a core Fog dependency
        begin
          # Because of how Google API gem was rewritten, we get to do all sorts
          # of funky things, like this nonsense.
          require "google/apis/monitoring_#{Fog::Google::Monitoring::GOOGLE_MONITORING_API_VERSION}"
          require "google/apis/compute_#{Fog::Compute::Google::GOOGLE_COMPUTE_API_VERSION}"
          require "google/apis/dns_#{Fog::DNS::Google::GOOGLE_DNS_API_VERSION}"
          require "google/apis/pubsub_#{Fog::Google::Pubsub::GOOGLE_PUBSUB_API_VERSION}"
          require "google/apis/sqladmin_#{Fog::Google::SQL::GOOGLE_SQL_API_VERSION}"
          require "google/apis/storage_#{Fog::Storage::GoogleJSON::GOOGLE_STORAGE_JSON_API_VERSION}"
          require "googleauth"
        rescue LoadError => error
          Fog::Errors::Error.new("Please install the google-api-client (>= 0.9) gem before using this provider")
          raise error
        end

        # Users can no longer provide their own clients due to rewrite of auth
        # in https://github.com/google/google-api-ruby-client/ version 0.9.
        if options[:google_client]
          raise ArgumentError.new("Deprecated argument no longer works: google_client")
        end

        # They can also no longer use pkcs12 files, because Google's new auth
        # library doesn't support them either.
        if options[:google_key_location]
          raise ArgumentError.new("Deprecated argument no longer works: google_key_location")
        end
        if options[:google_key_string]
          raise ArgumentError.new("Deprecated argument no longer works: google_key_string")
        end

        # Validate required arguments
        unless options[:google_api_scope_url]
          raise ArgumentError.new("Missing required arguments: google_api_scope_url")
        end

        application_name = "fog"
        unless options[:app_name].nil?
          application_name = "#{options[:app_name]}/#{options[:app_version] || '0.0.0'} fog"
        end

        ::Google::Apis::ClientOptions.default.application_name = application_name
        ::Google::Apis::ClientOptions.default.application_version = Fog::Google::VERSION

        auth = nil
        if options[:google_json_key_location] || options[:google_json_key_string]
          if options[:google_json_key_location]
            json_key_location = File.expand_path(options[:google_json_key_location])
            json_key = File.open(json_key_location, "r", &:read)
          else
            json_key = options[:google_json_key_string]
          end

          json_key_hash = Fog::JSON.decode(json_key)
          unless json_key_hash.key?("client_email") || json_key_hash.key?("private_key")
            raise ArgumentError.new("Invalid Google JSON key")
          end

          options[:google_client_email] = json_key_hash["client_email"]
          unless options[:google_client_email]
            raise ArgumentError.new("Missing required arguments: google_client_email")
          end

          if ENV["DEBUG"]
            ::Google::Apis.logger = ::Logger.new(::STDERR)
            ::Google::Apis.logger.level = ::Logger::DEBUG
          end

          auth = ::Google::Auth::ServiceAccountCredentials.make_creds(
            :json_key_io => StringIO.new(json_key_hash.to_json),
            :scope => options[:google_api_scope_url]
          )
        elsif options[:google_auth]
          auth = options[:google_auth]
        else
          raise ArgumentError.new(
            "Missing required arguments: google_json_key_location, "\
            "google_json_key_string or google_auth"
          )
        end

        ::Google::Apis::RequestOptions.default.authorization = auth
        auth
      end

      ##
      # Executes a request and wraps it in a result object
      #
      # @param [Google::APIClient::Method] api_method The method object or the RPC name of the method being executed
      # @param [Hash] parameters The parameters to send to the method
      # @param [Hash] body_object The body object of the request
      # @return [Excon::Response] The result from the API
      def request(api_method, parameters, body_object = nil, media = nil)
        client_parms = {
          :api_method => api_method,
          :parameters => parameters
        }
        # The Google API complains when given null values for enums, so just don't pass it any null fields
        # XXX It may still balk if we have a nested object, e.g.:
        #   {:a_field => "string", :a_nested_field => { :an_empty_nested_field => nil } }
        client_parms[:body_object] = body_object.reject { |_k, v| v.nil? } if body_object
        client_parms[:media] = media if media

        result = @client.execute(client_parms)

        build_excon_response(result.body.nil? || result.body.empty? ? nil : Fog::JSON.decode(result.body), result.status)
      end

      ##
      # Builds an Excon response
      #
      # @param [Hash] Response body
      # @param [Integer] Response status
      # @return [Excon::Response] Excon response
      def build_excon_response(body, status = 200)
        response = Excon::Response.new(:body => body, :status => status)
        if body && body.key?("error")
          msg = "Google Cloud did not return an error message"

          if body["error"].is_a?(Hash)
            response.status = body["error"]["code"]
            if body["error"].key?("errors")
              msg = body["error"]["errors"].map { |error| error["message"] }.join(", ")
            elsif body["error"].key?("message")
              msg = body["error"]["message"]
            end
          elsif body["error"].is_a?(Array)
            msg = body["error"].map { |error| error["code"] }.join(", ")
          end

          case response.status
          when 404
            raise Fog::Errors::NotFound.new(msg)
          else
            raise Fog::Errors::Error.new(msg)
          end
        end

        response
      end
    end
  end
end
