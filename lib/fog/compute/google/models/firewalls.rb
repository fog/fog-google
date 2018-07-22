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
          if identity
            firewall = service.get_firewall(identity).to_h
            return new(firewall)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
