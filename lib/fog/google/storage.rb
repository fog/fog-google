require "fog/google/storage_xml"
require "fog/google/storage_json"

module Fog
  module Storage
    class Google < Fog::Service     
      def self.new(options)
        if options.keys.include? :google_storage_access_key_id
          puts "Loading Fog::Storage::GoogleXML"
          Fog::Storage::GoogleXML.new(options)
        else
          puts "Loading Fog::Storage::GoogleJSON"
          Fog::Storage::GoogleJSON.new(options)
        end
      end
    end
  end
end

