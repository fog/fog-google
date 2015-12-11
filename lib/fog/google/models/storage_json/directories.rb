require "fog/core/collection"
require "fog/google/models/storage_json/directory"

module Fog
  module Google
    class StorageJSON
      class Directories < Fog::Collection
        model Fog::Google::StorageJSON::Directory

        def all
          # TODO: Write
        end

        def get(key, options = {})
          remap_attributes(options,             :delimiter  => "delimiter",
                                                :marker     => "marker",
                                                :max_keys   => "max-keys",
                                                :prefix     => "prefix")
          data = service.get_bucket(key, options).body
          directory = new(:key => data["name"])
          # options = {}
          # for k, v in data
          #   if %w(commonPrefixes delimiter IsTruncated Marker MaxKeys Prefix).include?(k)
          #     options[k] = v
          #   end
          # end
          # directory.files.merge_attributes(options)
          # directory.files.load(data["contents"])
          directory
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
