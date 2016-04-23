module Fog
  module Storage
    class Google < Fog::Service
      def self.new(options = {})
        begin
          fog_creds = Fog.credentials
        rescue
          fog_creds = nil
        end

        if options.keys.include?(:google_storage_access_key_id) ||
           (!fog_creds.nil? && fog_creds.keys.include?(:google_storage_access_key_id))
          Fog::Storage::GoogleXML.new(options)
        else
          Fog::Storage::GoogleJSON.new(options)
        end
      end
    end
  end
end
