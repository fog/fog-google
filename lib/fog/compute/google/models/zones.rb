module Fog
  module Compute
    class Google
      class Zones < Fog::Collection
        model Fog::Compute::Google::Zone

        def all
          data = service.list_zones.to_h[:items] || []
          load(data)
        end

        def get(identity)
          data = service.get_zone(identity).to_h
          new(data)
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
