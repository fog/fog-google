module Fog
  module Compute
    class Google
      class Firewalls < Fog::Collection
        model Fog::Compute::Google::Firewall

        def all(opts = {})
          data = service.list_firewalls(opts).to_h[:items]
          load(data || [])
        end

        def get(identity)
          if firewall = service.get_firewall(identity)
            new(firewall.to_h)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
