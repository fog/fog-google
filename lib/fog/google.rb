require "fog/core"
require "fog/json"
require "fog/xml"
require "fog/google/version"

module Fog
  module Google
    autoload :Compute, 'fog/google/compute/compute'
    autoload :DNS, 'fog/google/dns/dns'
    autoload :Mock, 'fog/google/mock'
    autoload :Monitoring, 'fog/google/monitoring'
    autoload :Pubsub, 'fog/google/pubsub'
    autoload :Shared, 'fog/google/shared'
    autoload :SQL, 'fog/google/sql'
    autoload :Storage, 'fog/google/storage/storage'
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
      autoload :Storage, 'fog/google/parsers/storage/storage'
    end
  end
end
