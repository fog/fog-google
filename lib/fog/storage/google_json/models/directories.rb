module Fog
  module Storage
    class GoogleJSON
      class Directories < Fog::Collection
        model Fog::Storage::GoogleJSON::Directory

        def all
          data = service.list_buckets.to_h[:items] || []
          load(data)
        end

        def get(key, options = {})
          remap_attributes(options,             :delimiter  => "delimiter",
                                                :marker     => "marker",
                                                :max_keys   => "max-keys",
                                                :prefix     => "prefix")
          data = service.get_bucket(key, options).to_h
          new(data)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
