module Fog
  module Google
    class Compute
      class Regions < Fog::Collection
        model Fog::Google::Compute::Region

        def all
          data = service.list_regions.to_h
          load(data[:items] || [])
        end

        def get(identity)
          if identity
            region = service.get_region(identity).to_h
            return new(region)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
