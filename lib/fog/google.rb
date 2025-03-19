require "fog/core"
require "fog/json"
require "fog/xml"
require "fog/google/version"

module Fog
  module Google
    autoload :Compute, File.expand_path("../google/compute", __FILE__)
    autoload :DNS, File.expand_path("../google/dns", __FILE__)
    autoload :Mock, File.expand_path("../google/mock", __FILE__)
    autoload :Monitoring, File.expand_path("../google/monitoring", __FILE__)
    autoload :Pubsub, File.expand_path("../google/pubsub", __FILE__)
    autoload :Shared, File.expand_path("../google/shared", __FILE__)
    autoload :SQL, File.expand_path("../google/sql", __FILE__)
    autoload :Storage, File.expand_path("../google/storage", __FILE__)
    autoload :StorageJSON, 'fog/google/storage/storage_json'
    autoload :StorageXML, 'fog/google/storage/storage_xml'

    extend Fog::Provider

    service(:compute, "Compute")
    service(:dns, "DNS")
    service(:monitoring, "Monitoring")
    service(:pubsub, "Pubsub")
    service(:storage, "Storage")
    service(:sql, "SQL")

    # CGI.escape, but without special treatment on spaces
    def self.escape(str, extra_exclude_chars = "")
      # '-' is a special character inside a regex class so it must be first or last.
      # Add extra excludes before the final '-' so it always remains trailing, otherwise
      # an unwanted range is created by mistake.
      str.gsub(/([^a-zA-Z0-9_.#{extra_exclude_chars}-]+)/) do
        "%" + Regexp.last_match(1).unpack("H2" * Regexp.last_match(1).bytesize).join("%").upcase
      end
    end

    module Parsers
      autoload :Storage, 'fog/google/parsers/storage'
    end
  end
end
