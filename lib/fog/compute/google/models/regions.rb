module Fog
  module Compute
    class Google
      class Regions < Fog::Collection
        model Fog::Compute::Google::Region

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
