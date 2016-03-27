module Fog
  module Storage
    class GoogleJSON
      class Directories < Fog::Collection
        model Fog::Storage::GoogleJSON::Directory

        # TODO get_service does not return items like this
        # def all
        #   data = service.get_service.body["items"]
        #   load(data)
        # end

        def get(key, options = {})
          remap_attributes(options,             :delimiter  => "delimiter",
                                                :marker     => "marker",
                                                :max_keys   => "max-keys",
                                                :prefix     => "prefix")
          data = service.get_bucket(key, options).body
          new(:key => data["name"])
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
