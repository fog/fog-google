require "fog/google/storage_xml"
require "fog/google/storage_json"

module Fog
  module Storage
    class Google < Fog::Service
      def self.new(options = {})
        if options.keys.join(" ").include? "client_email" or
          Fog.credentials.keys.join(" ").include? "client_email"
          Fog::Storage::GoogleJSON.new(options)
        else
          Fog::Storage::GoogleXML.new(options)
        end
      end
    end
  end
end
