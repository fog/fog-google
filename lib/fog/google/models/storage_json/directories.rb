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

        def get(_key, _options = {})
          # TODO: Write
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
