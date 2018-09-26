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
          if identity
            url_map = service.get_url_map(identity).to_h
            return new(url_map)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
