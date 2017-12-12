module Fog
  module Compute
    class Google
      class ForwardingRules < Fog::Collection
        model Fog::Compute::Google::ForwardingRule

        def all(region: nil, filter: nil, max_results: nil,
                order_by: nil, page_token: nil)

          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }

          if region
            data = service.list_forwarding_rules(region, opts).items
          else
            data = []
            service.list_aggregated_forwarding_rules(opts).items
                   .each_value do |scoped_list|
              if scoped_list && scoped_list.forwarding_rules
                data.concat(scoped_list.forwarding_rules)
              end
            end
          end
          load(data.map(&:to_h))
        end

        def get(identity, region = nil)
          response = nil
          if region
            response = service.get_forwarding_rule(identity, region).to_h
          else
            response = all(
              :filter => "name eq #{identity}", :max_results => 1
            ).first
            response = response.attributes unless response.nil?
          end

          return nil if response.nil?
          new(response)
        end
      end
    end
  end
end
