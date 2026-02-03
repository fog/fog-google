module Fog
  module Google
    class Storage < Fog::Service
      GOOGLE_STORAGE_HOST = "storage.googleapis.com".freeze

      # Shared utilities for both JSON and XML storage implementations
      module Utils
        def self.storage_host_for_universe(universe_domain)
          domain = universe_domain.to_s.strip
          if !domain.empty? && domain != "googleapis.com"
            "storage.#{domain}"
          else
            GOOGLE_STORAGE_HOST
          end
        end
      end

      def self.new(options = {})
        begin
          fog_creds = Fog.credentials
        rescue StandardError
          fog_creds = nil
        end

        if options.keys.include?(:google_storage_access_key_id) ||
           (!fog_creds.nil? && fog_creds.keys.include?(:google_storage_access_key_id))
          Fog::Google::StorageXML.new(options)
        else
          Fog::Google::StorageJSON.new(options)
        end
      end
    end
  end
end
