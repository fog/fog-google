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
          if rule = service.get_global_forwarding_rule(identity).to_h
            new(rule)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
