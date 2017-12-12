module Fog
  module Compute
    class Google
      class UrlMaps < Fog::Collection
        model Fog::Compute::Google::UrlMap

        def all
          data = service.list_url_maps.to_h[:items] || []
          load(data)
        end

        def get(identity)
          if url_map = service.get_url_map(identity).to_h
            new(url_map)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
