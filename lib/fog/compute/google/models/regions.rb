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
          if region = service.get_region(identity).to_h
            new(region)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
