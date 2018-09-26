module Fog
  module Compute
    class Google
      class GlobalForwardingRules < Fog::Collection
        model Fog::Compute::Google::GlobalForwardingRule

        def all(opts = {})
          data = service.list_global_forwarding_rules(opts).to_h[:items] || []
          load(data)
        end

        def get(identity)
          if identity
            rule = service.get_global_forwarding_rule(identity).to_h
            return new(rule)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end
      end
    end
  end
end
