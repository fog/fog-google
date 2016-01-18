require "fog/google/storage_xml"
require "fog/google/storage_json"

module Fog
  module Storage
    class Google < Fog::Service     
      def self.new(options)
        if options.keys.include? :google_storage_access_key_id
          Fog::Storage::GoogleXML.new(options)
        else
          Fog::Storage::GoogleJSON.new(options)
        end
      end
    end
  end
end

